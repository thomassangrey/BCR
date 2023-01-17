function [uc,vc] = ctocenter(u,v)
% From staggered field u,v to centered values
val=size(u);
uc=u;
vc=v;
for i=1:val(1)-1
    for j=1:val(2)
        uc(i,j)=(u(i,j)+u(i+1,j))/2;
    end
end
for i=1:val(1)
    for j=1:val(2)-1
        vc(i,j)=(v(i,j)+v(i,j+1))/2;
    end
end
