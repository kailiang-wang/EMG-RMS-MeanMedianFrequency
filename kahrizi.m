clear all;close all;clc
warning off all
[FileName,PathName] = uigetfile('*.txt','Select the file');
load([PathName FileName]); 
clear PathName FileName
c=who;
cc=c(1);
ccc=cc{:};
xx=eval([cc{:}]);
[rr,cl]=size(xx);
fs=1000;
[b,a]=butter(4,[20 450]./(fs/2));
status='wait...'
for ii=1:cl
    x=xx(:,ii);
    x=filter(b,a,x);
    for jj=1:floor(length(x)/fs)/0.2
        seg=x((jj-1)*0.2*fs+1:jj*0.2*fs)';
        FMN(jj,ii)=myfmn_kah(seg,fs);
        FMD(jj,ii)=myfmd_kah(seg,fs);
        RMS(jj,ii)=myrms_kah(seg);
    end
end
for i=1:cl
    t=0.2:0.2:floor(length(x)/fs);
    t10=floor(0.1*length(t));
    A=[t' ones(length(FMN(:,i)),1)];  
    Y1=FMN(:,i);
    Y2=FMD(:,i);
    Y3=RMS(:,i);
    as=inv(A'*A)*A'*Y1;
    fmn_slp(i)=as(1); fmn_bis(i)=as(2);
    as2=inv(A'*A)*A'*Y2;
    fmd_slp(i)=as2(1); fmd_bis(i)=as2(2);
    as3=inv(A'*A)*A'*Y3;
    rms_slp(i)=as3(1); rms_bis(i)=as3(2);
    for j=1:floor(length(t)/t10)
        A10=[t((j-1)*t10+1:j*t10)' ones(length(t((j-1)*t10+1:j*t10)'),1)];
        Y101=FMN((j-1)*t10+1:j*t10,i);
        Y102=FMD((j-1)*t10+1:j*t10,i);
        Y103=RMS((j-1)*t10+1:j*t10,i);
        as101=inv(A10'*A10)*A10'*Y101;
        as102=inv(A10'*A10)*A10'*Y102;
        as103=inv(A10'*A10)*A10'*Y103;
        fmn_slp_10percents(j,i)=as101(1); fmn_bis_10percents(j,i)=as101(2);
        fmd_slp_10percents(j,i)=as102(1); fmd_bis_10percents(j,i)=as102(2);
        rms_slp_10percents(j,i)=as103(1); rms_bis_10percents(j,i)=as103(2);
    end
end
for i=1:cl
    subplot(cl,1,i);
    plot(t(1:end-1),FMN(1:end-1,i),'.r'); hold on; plot(t(1:end-1),fmn_slp(i).*t(1:end-1)+fmn_bis(i));
    title(['Mean Power Frequency (MNF) variation of channel #' num2str(i)]);
    xlabel('time(s)');  ylabel('MNF');
end
figure
for i=1:cl
    subplot(cl,1,i);
    plot(t(1:end-1),FMD(1:end-1,i),'.r'); hold on; plot(t(1:end-1),fmd_slp(i).*t(1:end-1)+fmd_bis(i));
    title(['Median Power Frequency (MDF) variation of channel #' num2str(i)]);
    xlabel('time(s)'); ylabel('MDF');
end
status='Completed.  Double click on variables in workspace'
 
clear status A X1 Y1 Y2 a as as2 b c cc ccc cl fs i j r seg t x xx ii jj fmn_bis fmd_bis
    
