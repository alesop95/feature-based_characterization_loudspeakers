function [SM_hand, SM] = smoothness(spec,freq)

x = log(freq);          % natural logarithm of the frequency spectrum
y = spec;

%%%% Preprocessing
% x = zscore(x);
% y = zscore(y);

%% BY HAND REGRESSION AND THEN COMPUTE R2 METRIC

n = length(x);
Phi = [ones(n,1) x];     % Consider the feature matrix Phi with a constant term and a linear term.
                         % Matrix can be expanded by adding new columns, e.g., if we want to consider also a quadratic
                         % term we write: Phi = [ones(n_sample,1) x x.^2]; 

mpinv = pinv(Phi' * Phi) * Phi';
w = mpinv * y;
% W =(X^TX)^(?1)*(X^T)*Y
% Dove la X del sito:
% https://stats.stackexchange.com/questions/266631/what-is-the-difference-between-least-square-and-pseudo-inverse-techniques-for-li
% E' la "Phi" dello script qui
% la pseudo inverse con pinv() matlab la fa a posto dell'inversa ma la LS
% solution è quella tutta intera sopra

% % PREDICTED VALUE
hat_y = Phi * w;

% % METRIC COMPUTATION
bar_t = mean(y);
SSR = sum((y-hat_y).^2);
R_squared = 1 - SSR / sum((y-bar_t).^2);
SM_hand = R_squared;


%% OR COMPUTE DIRECTLY FROM STATISTICS

SM = ( (n*(sum(x.*y)) - (sum(x))*(sum(y))) / sqrt( (n*sum(x.^2)-(sum(x))^2)*(n*sum(y.^2)-(sum(y))^2) ) )^2;


end

