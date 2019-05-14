function [Map_Field_new,D_Field]=Map_Field_update(Map_Field_old,sigma_rot,power_rot,position_old,HX,HY)
% x=position_old(1);
% y=position_old(2);
% temp=power_rot*exp(-(HX-position_old(1))^2/sigma_rot^2-(HY-position_old(2))^2/sigma_rot^2);
% D_Field=zeros(2000,2000);
% D_Field(y-50:y+50,x-50:x+50)=temp;
% Map_Field_new=Map_Field_old-D_Field;
D_Field=power_rot*exp(-((HX-position_old(1)).^2)/(sigma_rot^2)-((HY-position_old(2)).^2)/(sigma_rot^2));
Map_Field_new=Map_Field_old-D_Field;
