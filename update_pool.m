function pool= update_pool(Pool,index)
[rownum,~]=find(Pool(:,end)==index);
pool=Pool([1:rownum-1,rownum+1:end],:);
end