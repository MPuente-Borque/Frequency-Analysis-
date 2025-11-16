function omegacutoff = wavhighfreq_v2(wavname,ga,be)
%
% Internal function. Determine high frequency cutoff (small scale)
% for wavelets. This determines s0 in the CWT

% Create frequency vector for computations
domega = (12*pi)/1000;
omega = 0:domega:12*pi;



if strcmpi(wavname,'morse') && ~isempty(ga) && ~isempty(be)
    % 50 percent energy drop off cutoff for Morse wavelets
    alpha = 1;
    anorm = morsenormconstant(ga,be);
    psihat = anorm*omega.^be.*exp(-omega.^ga);
    idx = find(psihat> alpha,1,'last');
    omegacutoff = omega(idx);
    
elseif strcmpi(wavname,'bump')
    % 90 percent energy drop off for bump
    alpha = 0.2;
    mu = 5; sigma = 0.6;
    w = (omega-mu)./sigma;
    expnt = -1./(1-abs(w).^2);
    psihat = 2*exp(1)*exp(expnt).*(abs(w)<1-eps);
    idx = find(psihat> alpha,1,'last');
    omegacutoff = omega(idx);
    
    
    
elseif strcmpi(wavname,'amor')
    % 90 percent energy drop off for Morlet
    alpha = 0.2; 
    cf = 6;
    psihat = 2*exp(-(omega-cf).^2/2).*(omega>0);
    idx = find(psihat> alpha,1,'last');
    omegacutoff = omega(idx);
    
end






function anorm = morsenormconstant(ga,be)
% anorm = morsenormconstant(ga,be) returns the normalizing constant so that
% the 0-th order Morse wavelet at the peak frequency is equal to 2.
% \gamma and \beta must be real-valued and positive
validateattributes(ga,{'numeric'},{'real','scalar','>=',1});
validateattributes(ga,{'numeric'},{'real','scalar','>',(ga-1)/2});

anorm = 2*exp(be/ga*(1+(log(ga)-log(be))));