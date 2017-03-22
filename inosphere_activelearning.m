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
   spambase=[spambase,(1:n)'];
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

global D P Q P_word_class P_class;
P=n_train-1;
D=1;
train_size=100;


sample_ratio=0.1;
Pool=train_data(2:n_train,:);
[P_class,P_word_class,Q] = initialize(train_data,d);
error=zeros(train_size,1);


test_error=zeros(train_size,1);
for active_i=1:train_size
    tic
	rp=randperm(P);
	sample=Pool(rp(1:floor(n_train*sample_ratio)),:);
	Index=argmin(sample,train_data);
	[P_class,P_word_class,Q] =update(Index,spambase,train_data(Index,d+1),d);
	P=P-1;
	D=D+1;
	Pool=update_pool(Pool,Index);
	error(active_i)=err(P_class,P_word_class,Q,P);
	for i=1:length(test_data)
    	q=P_class(1)*prod(P_word_class(3,:,1).^test_data(i,1:d))/...
    	(P_class(1)*prod(P_word_class(3,:,1).^test_data(i,1:d))+...
    	P_class(2)*prod(P_word_class(3,:,2).^test_data(i,1:d)));
    	if (q>0.5&&test_data(i,d+1)==1 || q<=0.5&&test_data(i,d+1)==0)
        	test_error(active_i)=test_error(active_i)+1;
    	end
	end
	test_error(active_i)=test_error(active_i)/length(test_data);
    disp([int2str(active_i),'     ',num2str(toc)])
end
h2=figure;
figure(h2)
plot(test_error,'r') 

%%

%%
test_a=test_error;
%%

%figure(h1)
%plot(error);
%title('training error')
h2=figure;
figure(h2)
plot(test_error,'r')

ylabel('Test error');
xlabel('Number of training data')
hold on

%
Pool2=train_data;
[P_class,P_word_class,Q] = initialize(train_data,d);
error2=zeros(train_size,1);


test_error2=zeros(train_size,1);
P=n_train-1;
D=1;
[P_class,P_word_class,Q] = initialize(train_data,d);
for active_i=1:train_size
	rp2=randperm(P);
	Index2=Pool2(rp2(1),end);
	[P_class,P_word_class,Q] =update(Index2,spambase,train_data(Index2,d+1),d);
	P=P-1;
	D=D+1;
	Pool2=update_pool(Pool2,Index2);
	error2(active_i)=err(P_class,P_word_class,Q,P);
	for i=1:length(test_data)
    	q=P_class(1)*prod(P_word_class(3,:,1).^(test_data(i,1:d)))/...
    	(P_class(1)*prod(P_word_class(3,:,1).^(test_data(i,1:d)))+...
    	P_class(2)*prod(P_word_class(3,:,2).^(test_data(i,1:d))));
    	if (q>0.5&&test_data(i,d+1)==1 || q<=0.5&&test_data(i,d+1)==0)
        	test_error2(active_i)=test_error2(active_i)+1;
    	end
	end
	test_error2(active_i)=test_error2(active_i)/length(test_data);
end


plot(test_error2,'b')
legend('Active learning','Random sampling');
