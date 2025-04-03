function [mP2, f2, eP2]=fourier_bootstrap_MPB(x,color)
%input: x= [tiempo|señal|error]
        % color, hexadecimal para dibujar la gráfica 
%output  mP2 Power spectrum
        % f2 frecuency
        % eP2 Power spectrum error
format long


tc=x(:,1);
for n=1:5000
    nx=x(:,2)+randn(length(x),1).*x(:,3);
    sig2=(nx-mean(nx))/std(nx);
    Fs = 1/(tc(2)-tc(1));         % Sampling Rate
    [P2(:,n),f2] = periodogram(sig2,[],[],Fs,'power');
%     plot(f2,P2(:,n));hold on;
end
xlabel('Frequency (1/yr)')
ylabel('Amplitude')
grid on
% axis([0 4e-3 0 max(max(P2))])
%figure
mP2=mean(P2');
eP2=std(P2');

plot(f2,mP2,'Color',color,'LineWidth',2);hold on

e1=fill([f2' fliplr(f2')],[(mP2-eP2) fliplr((mP2+eP2))], color,'LineStyle','none');
alpha(e1,0.2);

xlabel('Frequency (1/yr)')
ylabel('Amplitude')
grid on
% axis([0 5e-3 0 max(mP2)+max(eP2)])
