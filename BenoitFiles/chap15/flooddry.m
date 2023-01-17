function [hulimited] = flooddry(hu,h,hmin) 

Ms=size(h);
M=Ms(2);
myhmin=hmin;
hulimited=hu;

% Whenever the layer depth is too small, force transport to zero if in the
% direction that could cause problems (empying an already empty box)
for i=2:M
    if h(i-1) < hmin*3
        hulimited(i)=min(hu(i),0);
    end
    if h(i) < hmin*3
        hulimited(i)=max(hu(i),0);
    end
end