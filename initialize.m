function [P1_class, P1_word_class, Q1] = initialize(train_data,d)


global n_class n_train;
P1_class=zeros(n_class,1);
P1_word_class=zeros(3,d,n_class);
class=train_data(1,d+1);
Q1=zeros(n_train,n_class+1);
P1_class(class+1)=1;


for i=1:d
    for j=1:n_class
        if (j==class+1)
            P1_word_class(1,i,j)=1+train_data(1,i);
            P1_word_class(2,i,j)=d+sum(train_data(1,1:d));
            P1_word_class(3,i,j)=P1_word_class(1,i,j)/P1_word_class(2,i,j);
        else
            P1_word_class(1,i,j)=1;
            P1_word_class(2,i,j)=d;
            P1_word_class(3,i,j)=1/d;
        end
    end
end


for i=1:n_train
    for j=1:n_class
        Q1(i,j)=P1_class(j)*prod(P1_word_class(3,:,j).^train_data(i,1:d));
    end
end


Q1(1,end)=1;


end
