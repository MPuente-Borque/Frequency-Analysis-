function comparison_fq_coherence_bootstrap_MPB(c1,c2)
    % imput c1: curve 1 [time| signal | err]
    % imput c2: curve 2 [time| signal | err]
    % Note: c1 and c2 have to have the same sampling and number of rows. 
    % note that boostract makes high freq lost coherence 
    format long
    % Prepare the curves--------------------------------------------------
    %curve 1
    dm0=(c1(:,2)-mean(c1(:,2)))/std(c1(:,2)); % remove mean and normalised
    edm0=c1(:,3)/std(c1(:,2));  % remove mean and normalised of the error
    tm=c1(:,1); %time
    
    %curve 2
    c0=(c2(:,2)-mean(c2(:,2)))/std(c2(:,2));% remove mean and normalised% remove mean and normalised
    ec0=c2(:,3)/std(c2(:,2));% remove mean and normalised of the error
    tc=c2(:,1);%time
    tcn=tc;

    % Bootstrap--------------------------------------------
    nn=5000; % number of iterations
    Fs = 1/(tc(2)-tc(1));
    [ss,fss] = mscohere(ones(length(tcn),1),ones(length(tcn),1),[],[],[],Fs);
    Cxy=zeros(length(fss),nn);phase=Cxy;
    for i=1:nn
        dm=dm0+edm0.*randn(length(tm),1);
        c=c0+ec0.*randn(length(tc),1);
        DMn=interp1(tm,dm,tcn);
        Cn=c;%(tc<=1980);
        sig1=Cn;
        sig2=DMn;
                
        [Cxy(:,i),f] = mscohere(sig1,sig2,[],[],[],Fs);
        Pxy     = cpsd(sig1,sig2,[],[],[],Fs);
        phase(:,i)   = -angle(Pxy)/pi*180;
        % [pks,locs] = findpeaks(Cxy,'MinPeakHeight',0.5);
    end
    % Plot the resuts --------------------------------------------------
    ax1 = axes('Position',[0.13,0.11,0.334659090909091,0.75],'Box','on');
    ax2 = axes('Position',[0.13,0.11,0.334659090909091,0.75],'Box','on');
    ax3 = axes('Position',[0.570340909090909,0.11,0.334659090909091,0.75],'Box','on');
    ax4 = axes('Position',[0.570340909090909,0.11,0.334659090909091,0.75],'Box','on');
        
    % plot coherence --
    plot(ax1,f,max(Cxy'),'Color',[211,211,211]/255,'LineWidth',1); hold(ax1,'on')%maxima
    plot(ax1,f,min(Cxy'),'Color',[211,211,211]/255,'LineWidth',1); hold(ax1,'on')%minima
   
    cxyb=Cxy;
    plot(ax1,f,mean(cxyb'),'Color',[0,0,139]/255,'LineWidth',2); hold(ax1,'on')%mean
    plot(ax1,f,mean(cxyb')+std(cxyb'),'Color',[0,0,139]/255,'LineWidth',1); hold(ax1,'on')%+1std
    plot(ax1,f,mean(cxyb')-std(cxyb'),'Color',[0,0,139]/255,'LineWidth',1); hold(ax1,'on')%-1std

    ax1.XLabel.String='Frecuency (1/yr)';
    ax1.YLabel.String ='Coherence Estimate';
    ax1.XTick=(0.5:0.5:4)*10^-3;
    ax1.XLim=[0.5e-3 4e-3];
    ax1.YLim=[0 0.8];
    ax1.XGrid='on'; ax1.YGrid='on';
%     xline(ax1,1/700,':','LineWidth',2) %mark T=700 yr
    %ax1.FontSize=20;

    ax2.XAxisLocation = 'top';
    ax2.Color = 'none';
    ax2.YAxisLocation = 'right';
    ax2.XLabel.String='Period (yr)';
    ax2.XLim=[0.5e-3 4e-3];
    etiquetasT=round(1./((0.5:0.5:4)*10^-3));
    ax2.XTickLabels=etiquetasT;
    ax2.XTick=(0.5:0.5:4)*10^-3;
    ax2.YColor="none";
    %ax2.FontSize=20;
    % hgca = gca;
    % hgca.XTick = f(locs);
    % hgca.YTick = 0.5;
    %axis([0 4e-3 0 1])
        
    % plot Phase ------------------------------
    
    plot(ax3,f,max(phase'),'Color',[211,211,211]/255,'LineWidth',1); hold(ax3,'on');
    plot(ax3,f,min(phase'),'Color',[211,211,211]/255,'LineWidth',1); hold(ax3,'on');

    phaseb=phase;
    plot(ax3,f,mean(phaseb'),'Color','r','LineWidth',2);hold on
    plot(ax3,f,mean(phaseb')+std(phaseb'),'Color','r','LineWidth',1);hold(ax3,'on')
    plot(ax3,f,mean(phaseb')-std(phaseb'),'Color','r','LineWidth',1);hold(ax3,'on')
    
    ax3.XLabel.String='Frecuency (1/yr)';
    ax3.YLabel.String ='Cross-spectrum Phase (degree)';
    ax3.XTick=(0.5:0.5:4)*10^-3;
    ax3.XLim=[0.5e-3 4e-3];
    ax3.YLim=[-180 180];
    ax3.XGrid='on'; ax3.YGrid='on';
    xline(ax3,1/700,':','LineWidth',2)
    %ax3.FontSize=20;

    ax4.XAxisLocation = 'top';
    ax4.Color = 'none';
    ax4.YAxisLocation = 'right';
    ax4.XLabel.String='Period (yr)';
    ax4.XLim=[0.5e-3 4e-3];
    etiquetasT=round(1./((0.5:0.5:4)*10^-3));
    ax4.XTickLabels=etiquetasT;
    ax4.XTick=(0.5:0.5:4)*10^-3;
    ax4.YColor="none";
   % ax4.FontSize=20;
    % hgca = gca;
    % hgca.XTick = f(locs); 
    % hgca.YTick = round(phase(locs));
    
    %axis([0 4e-3 -180 180])
    
    