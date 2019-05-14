function Field_new = Field_update(Field_old,position_old,sigma_rot,power_rot,HX,HY)
temp=power_rot*exp(-(HX-position_old(1))^2/sigma_rot^2-(HY-position_old(2))^2/sigma_rot^2);
Field_temp=zeros(2000,2000);
Field_temp(position_old(1)-50:position_old(1)+50,position_old(2)-50:position_old(2)+50)=temp;
Field_new=Field_old-Field_temp;