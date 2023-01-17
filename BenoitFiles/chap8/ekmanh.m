function[u,v]= ekmanh(h,z,isol) 

if isol==1
% no pressure gradient, solution for boundary condition du/dz=1 dv/dz=0 
u=(sin(h)*sinh(h)*(cosh(z)*sin(z)-cos(z)*sinh(z))+cos(h)*cosh(h)*(cosh(z)*sin(z)+cos(z)*sinh(z)))/(cos(2*h)+cosh(2*h));
v=(-sin(h)*sinh(h)*(cosh(z)*sin(z)+cos(z)*sinh(z))+cos(h)*cosh(h)*(cosh(z)*sin(z)-cos(z)*sinh(z)))/(cos(2*h)+cosh(2*h));
else
% no wind stress, solution for ug = 1, vg=0
u=-exp(-z)*(exp(2*h)*(1+exp(2*z))*cos(2*h-z)+(exp(4*h)-exp(2*z))*cos(z))/(1+exp(4*h)+2*exp(2*h)*cos(2*h));
v=exp(-z)*(exp(2*h)*(-1+exp(2*z))*sin(2*h-z)+(exp(4*h)-exp(2*z))*sin(z))/(1+exp(4*h)+2*exp(2*h)*cos(2*h));
end