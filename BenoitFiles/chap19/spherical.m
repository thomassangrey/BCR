%clear all;
%% Parameters for the spherical harminics
m=3;
n=4;
% Number of sampling points for a mesh grid the sphere.
K=50;
% Creates a mesh grid on the sphere
[X Y Z]=sphere(K);


% For color scale
val0=zeros(15,1);
vali=[0.5:0.5/14:1].';
vald=[1:-0.5/14:0.5].';
values = [0.:(1-0.)*1/31:1].';
valuesb = [1:-(1-0.)*1/31:0.].';
valuesd=ones(32,1);
valuesc=zeros(64,1);
bluered=[ [val0' values' valuesd' vald']' [val0' values' valuesb' val0']' [vali' valuesd' valuesb' val0']'];
% end colorscale



% For each of the points on the meshgrid
for ii=1:K+1
    for jj=1:K+1
        % calculate the radius
        R=sqrt(X(ii,jj)*X(ii,jj)+Y(ii,jj)*Y(ii,jj)+Z(ii,jj)*Z(ii,jj));
        % The sinus of latitude 
        mu=sin(Z(ii,jj)/R);
        % Longitude
        th=jj/K*2*pi;
        % Then the Legendre polynomial for all values of M=0 to N. Hence P_n^m is the element M+1 of the array
        CC=legendre(n,mu);
        % And finally the requested function value
        C(ii,jj)=CC(m+1)*cos(m*th);
    end
end
% The show the field C projected on the sphere
surf(X,Y,Z,C)
colormap(bluered)
axis equal
title (['Spherhical harmonic m=' num2str(m) ' , n= ', num2str(n)])
axis off
