function [pef, Tmean, Tstd]=emd_bootstrap_MPB(x,N,res)
%input: x= [time|signal|error]
      %  N number of characteristic periods that come out without bootstrap
      %  res: Model resolution res= diff(t) x 4
      %         SHAWQ2k: 25x4=100yr SHADIF14k: 50x4=200yr 
% output: pef : period obteined in the boostrap
     %  Tmean: mean periods
     %  Tstd: 1sigma standar desviation

    t=x(:,1);
    signal=x(:,2);
    err=x(:,3);
    DT=t(2)-t(1);
    
    s=[];  pef=[]; k=0;
    for i=1:10000 %bootstrap 
    
        gh1=signal+err.*randn(length(signal),1);
        gh1=(gh1-mean(gh1))/std(gh1);
        [d,pe]=decom(t,gh1);
    
        pe(pe<=res)=[]; % delete when it detects periods< resolution
        %  If T1-T2< resolution. I consider it to be only a period of average value.
        Dpe=diff(pe);
        aux=[];
        for j=1:length(Dpe)
            if Dpe(j)<=res
                pe(j)=mean(pe(j:j+1));
                aux=[aux,j+1];
            end
        end
        pe(aux)=[];
        
        if size(pe,1)==1 && size(pe,2)==N % so it returns the same number of characteristic periods as without bootstrap or desired 
            k=k+1;
            pef=[pef;pe];
        end 
        
    end
    k % number of successfull boostrap with N IMF 
    Tmean=mean(pef);
    Tstd=std(pef);
return


function [datos,periods]=decom(t,gh)

%preparación del tiempo
tini=t(1);
for i=1:length(t)
    if t(i)~=tini
        break
    end
end
nt=i-1;
inc=t(nt+1)-t(1);
tn=t(1):inc:t(end);%plot(tn,'*')
%Señal a analizar
x=gh;
%Empirical Mode Decomposition
IMF=emd(x);
[ffimf,ccimf]=size(IMF);
% figure
% subplot(ffimf+1,1,1)
% plot(tn,x,'r')
% axis tight
datos=tn';
for i=2:ffimf+1
% subplot(ffimf+1,1,i)
datos(:,i)=IMF(i-1,:)';
% plot(tn,IMF(i-1,:))
% axis tight
end
% save descomposicion_vdm.dat datos -ascii

%Autocorrelation Function (ACF)
c=1;
for i=2:ffimf
    [acf(:,i-1),lags(:,i-1),bounds(:,i-1)] = autocorr(IMF(i-1,:)',ccimf-1,[],2);
    [pksh,lcsh] = findpeaks(acf(:,i-1));
%     size(pksh)
     %isempty(lcsh)
     %if  isempty(pksh)==0 && isempty(~pksh)==0 && isempty(~lcsh)==0 && isempty(lcsh)==0  %no se que pasa pero sale vacio o cero a veces y peta el programa. 
    if  isempty(pksh)==0 && isempty(lcsh)==0  %no se que pasa pero sale vacio  a veces y peta el programa.   
        pico(:,c)=pksh(1);
        loc(:,c)=lcsh(1);
        c=c+1;
    else
       %fprintf('He visto el vacio\n')
    end
%     figure
%     autocorr(IMF(i-1,:)',ccimf-1,[],2)
end
% figure
% plot(lags*inc,acf)
periods=lags(loc)*inc;
return
