function NBD = nbd(spec,freq)

[f_exact,~,string] = fract_oct_freq_band(20, 100, 3514,1,1,1000);

% % The EXACT values are useful for calculations and making filters (center
% frequency)
temp = f_exact(:,2);            
temp_idx = zeros( size(f_exact(:,2),1) , 1 );

temp_destra = f_exact(:,3);  
temp_idx_destra = zeros( size(f_exact(:,2),1) , 1 );

temp_sinistra = f_exact(:,1);  
temp_idx_sinistra = zeros( size(f_exact(:,2),1) , 1 );


% % Retain indeces for....
for ii=1:size(temp,1)
    
    
    %%%%%%
    %%%%%%
    %%%%%%  true frequencies in the spectrum (y_b) 
[~,idx]=min(abs((freq-temp(ii))));
temp_idx(ii) = idx;
    %%%%%%  left index of band n
[~,idx_sinistra]=min(abs((freq-temp_sinistra(ii))));
temp_idx_sinistra(ii) = idx_sinistra;
    %%%%%%  right index of band n
[~,idx_destra]= min(abs((freq-temp_destra(ii))));
temp_idx_destra(ii) = idx_destra;

end


y_mean1_2_octaveband_n = zeros( size(f_exact(:,2),1) , 1 );
    %%%%%%
    %%%%%% y_mean
    %%%%%%
    for kk=1:size(temp,1)
y_mean1_2_octaveband_n(kk) = mean(spec(temp_idx_sinistra(kk):temp_idx_destra(kk)));
    end

NBD = sum(abs(y_mean1_2_octaveband_n - spec(temp_idx)))/size(string,1);
end

