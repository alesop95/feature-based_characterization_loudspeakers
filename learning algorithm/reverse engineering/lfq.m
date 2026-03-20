function LFQ = lfq(spec,freq,lfx_log,y_LW,idx300,lfx_freq)

%%%%%%%% For 1/20 octave band
%%% https://it.mathworks.com/matlabcentral/fileexchange/19033-nth-octave-frequency-bands?focused=3842661&tab=function
%%%




%%%%%%%%%%% 1) Split into N bands, from the lowest frequency defined by LFX 
%%%% (already available from previous calculation of LFX) up to 300 Hz
%%%% (whose index is available as well from above mentioned calculations)

lfx_freq = 10^(lfx_log);        % re-convert in the linear frequency corresponding value
upper = freq(idx300);

N_bands = 20;
[f_exact,~,string] = fract_oct_freq_band(N_bands, lfx_freq, upper,1,1,300);


% % The EXACT values are useful for calculations and making filters (center
% frequency)
temp = f_exact(:,2);
temp_idx = zeros( size(f_exact(:,2),1) , 1 );

% % To which numbers correspond these exact values in our spectrum at our
% disposal?
for ii=1:size(temp,1)
[~,idx]=min(abs((freq - temp(ii))));
temp_idx(ii) = idx;
end

LFQ = sum( abs(spec(temp_idx)- y_LW) / size(string,1));

