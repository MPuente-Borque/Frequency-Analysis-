function [periods,datos]=decomposition(data)
    % EMD Empirical Mode Decomposition (requires emd.m)
    %input: data[time , parameter] in 2 columns
    %output: Figure 1: (from top to bottom) original signal (red) IMF-1 
            % to IMF-n and residual
            %Figure 2: Autocorrelation functions of each IMF
            % periods: periods associated to each IMF
            % datos: IMF timeseries like in Fig1 
            %       [signal, IMF1,...,IMFn,Resiudual]
    format long
    
    %preparare time
    t=data(:,1);
    
    tini=t(1);
    for i=1:length(t)
        if t(i)~=tini
            break
        end
    end
    nt=i-1;
    inc=t(nt+1)-t(1);
    tn=t(1):inc:t(end);

    % Signal to be analysed
    x=data(:,2);
    %x=(x-mean(x))/std(x); % normalisation and elimination of the mean value
    
    % Empirical Mode Decomposition
    IMF=emd(x);
    [ffimf,ccimf]=size(IMF);
    figure
    subplot(ffimf+1,1,1)
    plot(tn,x,'r')
    axis tight
    datos=tn';
    for i=2:ffimf+1
    subplot(ffimf+1,1,i)
    datos(:,i)=IMF(i-1,:)';
    plot(tn,IMF(i-1,:))
    axis tight
    end
    % Autocorrelation Function (ACF)
    for i=2:ffimf
        [acf(:,i-1),lags(:,i-1),bounds(:,i-1)] = autocorr(IMF(i-1,:)',ccimf-1,[],2);
        [pksh,lcsh] = findpeaks(acf(:,i-1));
        pico(:,i-1)=pksh(1);
        loc(:,i-1)=lcsh(1);
    %     figure
    %     autocorr(IMF(i-1,:)',ccimf-1,[],2)
    end
    figure
    plot(lags*inc,acf)
    periods=lags(loc)*inc;

