function position_new=position_update(position_old,step_length,Map_Field_old,basepoint)
dx=Map_Field_old(position_old(2),position_old(1)+1)-Map_Field_old(position_old(2),position_old(1));
dy=Map_Field_old(position_old(2)+1,position_old(1))-Map_Field_old(position_old(2),position_old(1));

if(dx==0 & dy==0)
    R_vector=[];
    for i=1:3
        distance=sqrt((basepoint(i,1)-position_old(2))^2+(basepoint(i,2)-position_old(1))^2);
        R_vector=[R_vector;distance];
    end
    [m,n]=find(R_vector==min(R_vector));
    dx=basepoint(m,1)-position_old(1);
    dy=basepoint(m,2)-position_old(2);
end
position_new=double(int32(position_old+step_length*[dx;dy]/norm([dx;dy])));