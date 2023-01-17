clear all;

% PARAMETERS

M=100;
for i=1:M
    at(i)=1+i/100.;
    bt(i)=0.1*(sin(i-M))*5;
    ct(i)=-0.23*(i-M/2)/10;
    ft(i)=i;
end
bb=bt;
aa=at;
cc=ct;
ff=ft;

% TEST

cp=thomas(bt,at,ct,ft);

% RESULTS

for i=3:M-2
    diff(i)=(cp(i-1)*bb(i)+cp(i)*aa(i)+cp(i+1)*cc(i)-ff(i))/ff(i);
end

diff'