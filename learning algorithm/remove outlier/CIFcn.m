function[CI95] = CIFcn(data)

ym = data;
N = size(ym,1);
SEM = std(ym) / sqrt(N);                    % Standard Error Of The Mean
CI95 = SEM * tinv(0.975, N-1);              % 95% Confidence Intervals

end
