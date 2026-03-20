function [RMSE,R2,ADJR2] = error_metrics(Y_pred, Y,k)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% DOES THE MODEL EXPLAINS DATA??
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%just for avoid wrong orientated data errors
if size(Y, 1) ~= size(Y_pred, 1)
    Y = Y';
end

%%%%% See 03-Machine learning Ex.

N           = length(Y);

RSS       = sum((Y - Y_pred).^2);               % Residual sum of squares
SStot       = sum((Y - mean(Y)).^2);            % Total sum of squares


% % R-squared = 1 – (First Sum of Errors / Second Sum of Errors)   
%(1 - explained variation / total variation)
% 
% http://www.fairlynerdy.com/what-is-r-squared/
R2          = 1 - RSS/SStot;
RMSE        = sqrt(sum((Y - Y_pred).^2)/N);
                                            % n = number of observations
                                            % k = number of regressors
ADJR2       = 1 - RSS/SStot* (length(Y)-1)/(length(Y)-(k+1));   % adjust for the number of parameters