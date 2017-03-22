function y=logloss(x)
if isnan(x)
	y=0;
else if x==0||x==1
	y=0;
else
	y=x*log(x);
end
end
