function index = argmin(sample,spambase)


global n_class D P Q P_word_class P_class;
%ind=sample(:,end);


[n,d]=size(sample);
d=d-2;


error=zeros(n,1);


for i=1:n
    ind=sample(i,end); %global index
    %x_star=sample(i,:);
    if (Q(ind,end)==1)
        disp('sampling error')
    end
    [~,idx]=max(Q(ind,1:n_class));
    y_star=idx-1;
    [P_1,P_2,Q_1]=update(ind,spambase,y_star,d);
    error(i)=err(P_1,P_2,Q_1,P-1);
end
[~,minidx]=min(error);
index=sample(minidx,end);
end
