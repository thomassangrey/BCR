function [fp] = bcpert(f)
% Poundary conditions on perturbations
val=size(f);
M=val(1);
N=val(2);
fp=f;
% Perdiodic in x
fp(1,:)=fp(M-1,:);
fp(M,:)=fp(2,:);

% Condition on normal gradient on perturbation
% \int {\partial \psi'/\partial n} ds=0

 
        III1=0;
        III2=0;
        for jjj=2:M-1
            III1=III1+fp(jjj,N-1);
            III2=III2+fp(jjj,2);
            
        end
        for i=1:M
            fp(i,N)=III1/(M-2);
            fp(i,1)=III2/(M-2);
        end
    end


%fpt=fp;