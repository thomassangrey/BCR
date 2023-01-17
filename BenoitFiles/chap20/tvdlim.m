function [phi] = tvdlim(r) 

% Limiters for TVD schemes
% 1 : Superbee
% 2 : Van Leer
% 3 : MC
% 4 : Lax-Wendroff
% 5 : Upwind
% 6 : Beam warning

tvd = 1 ;

if tvd == 1
    phi=max(0,max(min(1,2*r),min(2,r)));
elseif tvd == 2
    phi=(r+abs(r))/(1+abs(r));
elseif tvd == 3
    phi=max(0,min(2*r,min((1+r)/2,2)));
elseif tvd == 4
    phi=1;
elseif tvd == 5
    phi=0;
elseif tvd == 6
    phi=r;
end
