 function P = createDurationObject(P,Units)
% This function creates a duration object output for wcoherence.
% The function takes either the Periods or the COI input and outputs

% Lo he cogido de una paginachina un poco chunga, no entiendo, debería
% estar en el toolbox de wavelet.


switch Units
    case 'secs'
        
        P = seconds(P);
        
    case 'mins'
        
        P = minutes(P);
        
    case 'hours'
        
        P = hours(P);
        
    case 'days'
        
        P = days(P);
        
    case 'years'
        
       P = years(P);
        
        
end