function [LFX_FREQ,IDX300,y_LW,LFX] = lfx(spec,freq)


%%%%%%%%%% 1) Calculate mean level mean_y_LW measured in listening window (LW) between 300 Hz-10 kHz.
[~,idx300]=min(abs((freq-300)));

[~,idx10000]=min(abs((freq-3514)));                     % <-----------------------si chiama 10000 ma è per 
                                                        %                   non cambiare ogni volta

mean_y_LW = mean(spec(idx300:idx10000));

%%%%%%%%%% 2) 
%%% Retain portion of spectrum before 300Hz
spec = spec(1:idx300);

%%% calculate all frequencies satisfying -6dB but then 
%%% retaining only the first below 300Hz (spectrum already in log values)
%%% satisfying the -6dBs wrt y_LW
mask = spec <= (mean_y_LW-6);    % logical vector
freq  = freq(mask);
freq = freq(end);                % Must be a single value here

%%%%%%%%%% 3) Final calculation according to definition
LFX = log10(freq);
y_LW = mean_y_LW;
IDX300 = idx300;
LFX_FREQ = freq;

end

