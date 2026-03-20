function env = spec_envelope(spec,freq)
% %
% % A VARIANT FROM MPEG7 with magnitude of DFT coefficient instead of power
% % spectrum
% % https://books.google.it/books?id=zbHVAQAAQBAJ&pg=PA98&lpg=PA98&dq=MPEG7+spectral+envelope+matlab&source=bl&ots=a_UYO5iU66&sig=ACfU3U1U7FXToDMEm6pcwk-jmmGsKLgWww&hl=it&sa=X&ved=2ahUKEwj8mPKfzOrnAhUnSxUIHSdfBfEQ6AEwAnoECAoQAQ#v=onepage&q=MPEG7%20spectral%20envelope%20matlab&f=false
% %

% R = [1/16,1/8,1/4,1/2,1,2,4,8];
% The index “r” gives me the resolution, since, as I decrease it, I decrease the bandwidth for each subband,
% and the difference between of ?loF?_b and ?hiF?_b decreases, so I’m basically increasing the resolution 
% as the overall bandwidth of the signal will be covered by more and more subbands
R = 1;       %% The lower R the greater the resolution!
M = 8/R;

lower = 62.5;
upper = 16000;

ASE = zeros(1,M);

for m=1:M
    %%% Compute left and right edges of the m-th frequency band
    IF_m = lower*2^((m-1)*R);
    rF_m = lower*2^((m)*R);
        
        %%% Prendo gli indici del valore in frequenza corrispondenti allo
        %%% spettro tutto insieme spec 
        [~,idx_left]=min(abs((freq-IF_m)));
        temp_idx_left = idx_left;
        [~,idx_right]=min(abs((freq-rF_m)));
        temp_idx_right = idx_right;
        
        spec_mth_subband = spec(temp_idx_left:temp_idx_right);
    
    
    %%% The sum of magnitude (here) coefficients in band m gives the SE coefficient for that frequency range. 
    %%% The coefficient for the band m is:
    % (if a frequency value falls between the boundary assign to the
    % leftmost bandwidth)
   
    ASE_m = sum(spec_mth_subband);
    ASE(m) = ASE_m;
    
end

    %%% Repeat previous step also for values from 20Hz to 62.5Hz and for
    %%% values from 16kHz to 20kHz
    %
%%%%%%%%%%%%% First band
    lower_first = 20;
    upper_first = 62.5;
        [~,idx_left_first]=min(abs((freq-lower_first)));
        temp_idx_left_first = idx_left_first;
        [~,idx_right_first]=min(abs((freq-upper_first)));
        temp_idx_right_first = idx_right_first;
         spec_mth_first = spec(temp_idx_left_first:temp_idx_right_first);
         ASE_first = sum(spec_mth_first);
     ASE = [ASE_first,ASE];
    %
    %
%%%%%%%%%%%%% Last band
    lower_last = 16000;
    upper_last = 20000;
        [~,idx_left_last]=min(abs((freq-lower_last)));
        temp_idx_left_last = idx_left_last;
        [~,idx_right_last]=min(abs((freq-upper_last)));
        temp_idx_right_last = idx_right_last;
        spec_mth_last = spec(temp_idx_left_last:temp_idx_right_last);
        ASE_last = sum(spec_mth_last);
     ASE = [ASE,ASE_last];
    

env = ASE;

end

