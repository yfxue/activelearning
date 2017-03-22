function [ spam ] = preprocess( spambase, d )


median_data=median(spambase(:,1:d));


[n,~]=size(spambase);


spam=spambase;


for i=1:n
    for j=1:d
        if (spambase(i,j)>=median_data(j))
            spam(i,j)=1;
        else
            spam(i,j)=0;
        end
    end
end


end
