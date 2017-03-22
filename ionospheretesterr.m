clear all
global n_class n_train;  
data = load ('ionosphere_dataset.mat');
     %clean up to remove some 0 BP 
   X = data.inst;
    Y=data.label;
    Xnew=[X,Y];
   [n,d] = size(Xnew);
   rperm = randperm(n);
   Xnew = Xnew(rperm,:);
   spambase=Xnew;
   d=d-1;
    spambase=preprocess(spambase,d);
   for i=1:size(spambase,1)
       if spambase(i,35)==-1
           spambase(i,35)=0;
       end
   end
   n_train=200;
   n_class=2;
    
  train_data = spambase(1:n_train,:);
   test_data = spambase(n_train+1:end,:);
      label_train=train_data(:,d+1);
label_test=test_data(:,d+1);
test_error=0;
P_class=zeros(n_class,1);
for i=1:n_class
	P_class(i)=sum(label_train==i-1)/n_train;
end
P_word_class=ones(d,n_class);
for t=1:d
	for i=1:n_train
    	P_word_class(t,train_data(i,d+1)+1)=P_word_class(t,train_data(i,d+1)+1)...
        	+train_data(i,t);
	end
end
for j=1:n_class
	den=sum(P_word_class(:,j));
	for t=1:d
    	P_word_class(t,j)=P_word_class(t,j)/den;
	end
end
Q=zeros(n_train,n_class);
for i=1:n_train
	for j=1:n_class
    	Q(i,j)=P_class(j)*prod(P_word_class(:,j).^(train_data(i,1:d)'));
	end
end
for i=1:n_train
	den=sum(Q(i,:));
	for j=1:n_class
    	Q(i,j)=Q(i,j)/den;
	end
end
	for i=1:length(test_data)
    	q=P_class(1)*prod(P_word_class(:,1).^(test_data(i,1:d)'))/...
    	(P_class(1)*prod(P_word_class(:,1).^(test_data(i,1:d)'))+...
    	P_class(2)*prod(P_word_class(:,2).^(test_data(i,1:d)')));
    	if (q>0.5&&test_data(i,d+1)==1 || q<=0.5&&test_data(i,d+1)==0)
        	test_error=test_error+1;
    	end
	end
	test_error=test_error/length(test_data)
