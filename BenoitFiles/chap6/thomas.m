function [x] = thomas (bt, at, ct, ft) 

%%  function [x] = thomas (b, a, c, f) 
%%  thomas algorithm for tridagiagonal systems as desribed in Appendix
%%  b, a, c are all of length m
%%  b lower diagonal with b(1)=0.
%%  a diagonal
%%  c upper diagonal c(m)=0
%%  Algorithm overrides a b c and f (used to store alpha beta gamma f)

b=bt;
a=at;
c=ct;
f=ft;
m = length(a);
for k=2:m 
  b(k)=b(k)/a(k-1);
  a(k)=a(k)-b(k)*c(k-1);
  f(k)=f(k)-b(k)*f(k-1);
end
x(m) = f(m) / a(m);
for k=m-1:-1:1
    x(k)=(f(k)-c(k)*x(k+1))/a(k);
end

