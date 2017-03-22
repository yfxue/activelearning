function [P1_class, P1_word_class, Q1] = update( Index,train_data,class, d )


global D P_class P_word_class Q n_train n_class


P1_class=zeros(size(P_class));
for i=1:n_class    
    if(class==i-1)
        P1_class(i)=(D*P_class(i)+1)/(D+1);
    else
        P1_class(i)=(D*P_class(i))/(D+1);
    end
end




data=train_data(Index,:);
P1_word_class=P_word_class;
for i=1:d
    P1_word_class(1,i,class+1)=P_word_class(1,i,class+1)+data(i);
    P1_word_class(2,i,class+1)=P_word_class(2,i,class+1)+sum(data(i:d));
    P1_word_class(3,i,class+1)=P1_word_class(1,i,class+1)/P1_word_class(2,i,class+1);
end


Q1=Q;


Q1(Index,n_class+1)=1;


%for i=1:n_train
%    if (Q1(i,end)==0)
%        for j=1:n_class
%            Q1(i,j)=Q1(i,j)/P_class(j)*P1_class(j);
%        end
%        Q1(i,class+1)=P1_class(class+1)*prod(P1_word_class(3,:,class+1).^train_data(i,1:d));
%    end
%end


for i=1:n_train
 	for j=1:n_class
    		if P_class(j)~=0
        			Q1(i,j)=Q1(i,j)/P_class(j)*P1_class(j);
    		else
        			Q1(i,j)=P1_class(j)*prod(P_word_class(3,:,j).^train_data(i,1:d))/...
            		(P_class(1)*prod(P_word_class(3,:,1).^train_data(i,1:d))+...
            		P_class(2)*prod(P_word_class(3,:,2).^train_data(i,1:d)));
    		end
 	end
    	Q1(i,class+1)=Q1(i,class+1)*prod((P1_word_class(3,:,class+1)./...
        		P_word_class(3,:,class+1)).^train_data(i,1:d));
 	den=sum(Q1(i,1:n_class));
 	for j=1:n_class			
     		Q1(i,j)=Q1(i,j)/den;
 	end
end




end





