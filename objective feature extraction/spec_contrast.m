function SC = spec_contrast(spec,freq)
%
%%%% Spectral contrast [jiang2002]
% %
% % 1. Sorting the FFT vector of the kth sub-band in a descending order 
% % 2. Choose a value for K (K=6 here) and alpha (recommended alpha = 0.02)
% and calculate peak_k and valley_k
% % 3. calculate SC_k = peak_k - valley_k as a k-dimensional raw Spectral Contrast feature

K = 6;
alpha = 0.02;

[f_exact_sc,~,~]=fract_oct_freq_band(1, 200, 10000,1,1,1000);

%%%%%% IN THIS WAY WE OBTAIN AN OCTAVE SUBBAND DIVISION WITH 6
%left    center   upper
% {'180','250','355';
% '355','500','710';
% '710','1.00k','1.40k';
% '1.40k','2.00k','2.80k';
% '2.80k','4.00k','5.60k';
% '5.60k','8.00k','11.0k'}

SC_temp = zeros(1,K);

for kk=1:K
    
    %%% Get boundary of the k-th subband
    left = f_exact_sc(kk,1);
    right = f_exact_sc(kk,3);
    
    %%% Prendo gli indici del valore in frequenza corrispondenti allo
    %%% spettro tutto insieme spec 
    [~,idx_left]=min(abs((freq-left)));
    temp_idx_left = idx_left;
    [~,idx_right]=min(abs((freq-right)));
    temp_idx_right = idx_right;
    
    spec_kth_subband = spec(temp_idx_left:temp_idx_right);
    spec_kth_subband_sorted = sort(spec_kth_subband,'descend');
    
    %%%% Length of the current portion of spectrum
    N = size(spec_kth_subband,1);
    upper_limit_of_summation = round(alpha*N);  %%% This number << N
    
    
    %%%% Compute Peak
    spec_kth_subband_peak = spec_kth_subband_sorted(1:upper_limit_of_summation);   %%% up to a certain point
        peak_k = log(sum(spec_kth_subband_peak)/alpha*N);
        
    %%%% Compute Valley
            temp_temp = sort(spec_kth_subband,'ascend');
    spec_kth_subband_valley = temp_temp(1:upper_limit_of_summation);   %%% TRICK: from last element of original vector inward
        valley_k = log(sum(spec_kth_subband_valley)/alpha*N);
    SC_temp(kk) = peak_k - valley_k;
    
end

SC = SC_temp;


end

