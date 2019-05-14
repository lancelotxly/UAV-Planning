function Map_Gauss_new=Map_Gauss_update(Map_Gauss_old,position_old,HX,HY,sigma_rot,power_rot)
x=position_old(1);
y=position_old(2);
hollow_matrix=power_rot*exp(-(HX-position_old(1)).^2/sigma_rot^2-(HY-position_old(2)).^2/sigma_rot^2);
Map_hollow=zeros(2000,2000);
Map_hollow(x-50:x+50,y-50:y+50)=hollow_matrix;
Map_Gauss_new=Map_Gauss_old-Map_hollow;