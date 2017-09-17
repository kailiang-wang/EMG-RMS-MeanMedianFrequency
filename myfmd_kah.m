function out=myfmd_kah(x,fs)
x=x-mean(x);
X=fft(x,256);
PX=X.*conj(X);
p=PX(1:128);
f=[0:127]./127.*(fs/2);
for i=1:length(p)-1
    e(i)=abs(sum(p(1:i))-sum(p(i+1:end)));
end
[~,k]=min(e);
out=f(k);