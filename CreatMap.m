clear all;clc;close all;
data=textread('datahigh.txt');
baseLoction=textread('basepoint.txt');  %装载搜索区域中心位置
basepoint=floor(baseLoction./(38.2));   %搜索区域中心位置对应的矩阵下标
Map_search=zeros(3000,3000);           %定义搜索区域地图
Map_barrier=zeros(3000,3000);          %定义限制区域地图
[NY,NX]=size(Map_search);
R_search=10000;                   %定义搜索范围10公里
for i=1:7
    for x=1:NX
        for y=1:NY
            if sqrt((abs(x-basepoint(i,1))*38.2)^2+(abs(y-basepoint(i,2))*38.2)^2) <= R_search
                Map_search(x,y)=1;
            end
        end
    end
end
[search_x,search_y]=find(Map_search==1);
[outHigh_x,outHigh_y]=find(data>=4150);  %找出高度超过飞行距离的位置（矩阵下标）
index=sub2ind(size(Map_barrier),outHigh_x,outHigh_y);   %高度超过飞行距离位置置为2
Map_barrier(index)=-1;
Map=Map_search+Map_barrier; 
Map_temp=Map(1:2000,1000:3000);
figure(1);mesh(1:2001,1:2000,Map_temp);xlabel('Y(m)');ylabel('X(m)');axis([0,2000,0,1200]);
data=data(1:2000,1000:2913);
figure(2);mesh(1:1914,1:2000,data);xlabel('X(m)');ylabel('Y(m)');grid on;;axis([0,1200,0,2000]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G_search
[HX,HY]=meshgrid(1:2000,1:2000);
A1=1e5;
sigma1=450;
Map_Field=A1*exp(-(HX-600).^2/sigma1^2-(HY-1800).^2/sigma1^2)+...
          A1*exp(-(HX-1500).^2/sigma1^2-(HY-1800).^2/sigma1^2)+...
          A1*exp(-(HX-1700).^2/sigma1^2-(HY-1000).^2/sigma1^2);
figure(3);contour(HX,HY,Map_Field);
%G_barrier
lambda=0.5;
[HX,HY]=meshgrid(0:1:100,0:1:100);
G_barrier=1e5*exp(-(HX-50).^2/lambda^2-(HY-50).^2/lambda^2);
%%%%%%
Map_barrier_Gauss=conv2(Map_barrier,G_barrier);
Map_Gauss_temp=Map_Field+Map_barrier_Gauss(1:2000,1001:3000);
figure(4);mesh(1:2000,1:2000,Map_Gauss_temp);xlabel('X(m)');ylabel('Y(m)');;axis([0,1200,0,2000]);
figure(5);contour(Map_Gauss_temp,50);xlabel('X(m)');ylabel('Y(m)');hold on;axis([0,1200,0,2000]);
%寻址与更新地图
step_length=10;
sigma_rot=45;
power_rot=2e3;
position_old=[300;300];
Map_Field_old=Map_Gauss_temp;
[HX,HY]=meshgrid(1:2000,1:2000);
basepoint=[600,1800;1500,1900;1700,1000];
iter=800;
for i=1:iter
    plot(position_old(1),position_old(2),'.');
    drawnow;
    position_new=position_update(position_old,step_length,Map_Field_old,basepoint);
    [Map_Field_new,D_Field]=Map_Field_update(Map_Field_old,sigma_rot,power_rot,position_old,HX,HY);
    
    position_old=position_new;
    Map_Field_old=Map_Field_new;
end
figure(6);mesh(1:2000,1:2000,Map_Field_new);