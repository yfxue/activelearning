function y=err(P1,P2,Q1,p)
global n_class n_train;
e=0;
for i=1:n_train
    if Q1(i,end)==0
        sumQ=sum(Q1(i,1:end-1));
        for j=1:n_class                    
            e=e+(Q1(i,j)/sumQ)*log(Q1(i,j)/sumQ);
	  % e=e+logloss(Q1(i,j));
        end
    end
end
e=e/p;
y=e;
end
