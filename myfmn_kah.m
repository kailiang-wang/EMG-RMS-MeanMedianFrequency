function out=myfmn_kah(x,fs)
x=x-mean(x);
X=fft(x,256);
PX=X.*conj(X);
p=PX(1:128);
f=[0:127]./127.*(fs/2);
out=(p*f')/sum(p);