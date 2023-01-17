function [kene,kens,ene,ens] = kmean(omfft,psifft,LX,LY)
% Mean wavenumber of kinetic energy and enstrophy
val=size(omfft);
M=val(1);
N=val(2);
% create wavenumbers from domain size and dimensions
[kx ky]=kxkyfft(omfft,LX,LY);

% Find size of the maximum wavenumber fitting into a circle
%  (integration over a disc, not a square, to really look
%    into wavenumbers that are represented)
 KMS=min(max(kx.^2),max(ky.^2));
% Energy
ene=0;
kene=0;
% Enstrophy
ens=0;
kens=0;
for ic=1:M
    for jc=1:N
        
        % squared wavenumber
        ks=(kx(ic)^2+ky(jc)^2);
        if ks <= KMS
        % Energy E of the mode
        eee=ks*abs(psifft(ic,jc))^2;
        % Enstrophy of the mode
        ees=abs(omfft(ic,jc))^2;
        % total values of energy
        ene=ene+eee;
        % total value if k E
        kene=kene+sqrt(ks)*eee;
        % Total value of enstrophy Z
        ens=ens+ees;
        % Total value of k Z
        kens=kens+sqrt(ks)*ees;
        end
    end
end
% Mean wavenumber of kinetic energy and Enstrophy
kene=kene/ene;
kens=kens/ens;
