function AAD = aad(spec,freq)

%%%%%%%% For 1/20 octave band
%%% https://it.mathworks.com/matlabcentral/fileexchange/19033-nth-octave-frequency-bands?focused=3842661&tab=function
% % 
% % f_exact is a 2D array of exact frequency bands in Hz.
% % f_exact( frequecy bands, [lower=1, center=2, upper =3;] );
% % 
% % f_nominal is a 2D array of nominal frequency bands in Hz.
% % f_nominal { frequecy bands, [lower=1, center=2, upper =3;] };
% % 
% % string is a 2D cell array of nominal frequency band strings in Hz.
% % string{ frequecy bands, [lower=1, center=2, upper =3;] };

[~,idx_200]=min(abs((freq-200)));
[~,idx_400]=min(abs((freq-400)));
y_ref = mean(spec(idx_200:idx_400));
[f_exact,~,string] = fract_oct_freq_band(20, 100, 3514,1,1,1000);

% % The EXACT values are useful for calculations and making filters (center
% frequency)
temp = f_exact(:,2);            
temp_idx = zeros( size(f_exact(:,2),1) , 1 );

% % Retain indeces for true frequencies in the spectrum
for ii=1:size(temp,1)
[~,idx]=min(abs((freq-temp(ii))));
temp_idx(ii) = idx;
end

AAD = sum(abs(y_ref - spec(temp_idx)))/size(string,1);

end

