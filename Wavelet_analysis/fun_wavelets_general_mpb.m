function []=fun_wavelets_general_mpb(signal,time,wname)

% Performs wavelet analysis of a signal 
% Uses the programmes in the folder  (cwt_program.m; wavhighfreq_v2;
% getDurationandUnits.m)  rather than Matlab's own wavelet function

% imput:  signal: signal to be analysed 
%         wname: morse / amor / bump (wavelet type)
%-------------------------------------------------------------------------

inc = abs(time(1)-time(2));
x = signal;
Fs = 1/inc;

%  Calculo y representacion de la wavelet
figure
cwt_program(x,wname,years(1/Fs),'VoicePerOctave',48);

colormap('jet') %Cambiar el colormap (usabamos jet)
axis ij % Invertir eje y
%title([titulo,' ',])

%%  graphical adjustments

% The X axis does not mark the signal's time window. It must be modified
% The Y axis goes in powers of 2).


    set(gca,'XTick',0:150:time(end)-time(1))
    set(gca,'XTickLabel',time(1):150:time(end))
    xtickangle(45)
%   yline(log2(700)) % Marks y=700 line


set(gca,'FontSize',12,'FontWeigh','bold')

end
