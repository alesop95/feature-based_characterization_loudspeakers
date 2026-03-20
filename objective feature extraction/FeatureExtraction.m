clc
clear all
close all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS
features  = ["decrease_ON","rolloff_ON","centroid_ON","spread_ON","kurtosis_ON", ...
    "entropy_ON","flatness_ON","crest_ON","slope_ON","spcontrast_ON",...
    "AAD_ON","envelope_thd", "flatness_thd"];

% features  = ["rolloff_ON","centroid_ON","spread_ON","kurtosis_ON", ...
%     "entropy_ON","flatness_ON","crest_ON","slope_ON","flatness_thd"];

N_woofer = 4;
N_tweeter = 4;
N_features = size(features,2);

X_w = zeros(N_woofer,N_features+5+9);     %%% two features are vectors of number 1x6 and 1x10
X_t = zeros(N_tweeter,N_features+5+9);

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%% READ 1/48 octave smoothed DATA by discarding phase (and header)information
%
%%%%% WOOFERS (follow same order in the listening room from sx to dx 1,2,3,4)
CK165_onaxis = csvread('./Input/WOOFERS/measurements/CK165_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
thII_onaxis = csvread('./Input/WOOFERS/measurements/thII_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
ESK165_onaxis = csvread('./Input/WOOFERS/measurements/ESK165_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
MPK165_onaxis = csvread('./Input/WOOFERS/measurements/MPK165_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);


CK165_thd_dB = csvread('./Input/WOOFERS/measurements/CK165_thd_dB.csv',6-1,0);
thII_thd_dB = csvread('./Input/WOOFERS/measurements/thII_thd_dB.csv',6-1,0);
ESK165_thd_dB = csvread('./Input/WOOFERS/measurements/ESK165_thd_dB.csv',6-1,0);
MPK165_thd_dB = csvread('./Input/WOOFERS/measurements/MPK165_thd_dB.csv',6-1,0);


X_woof_onaxis = [CK165_onaxis(:,2),thII_onaxis(:,2),ESK165_onaxis(:,2),MPK165_onaxis(:,2)];
X_woof_thd = [CK165_thd_dB(:,2),thII_thd_dB(:,2),ESK165_thd_dB(:,2),MPK165_thd_dB(:,2)];

%
%
%
%%%%% TWEETERS (follow same order in the listening room from sx to dx 1,2,3,4)
hertzc26_onaxis = csvread('./Input/TWEETERS/measurements/hertzc26_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
violino_onaxis = csvread('./Input/TWEETERS/measurements/violino_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
et26_5_onaxis = csvread('./Input/TWEETERS/measurements/et26_5_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);
mp25_3_onaxis = csvread('./Input/TWEETERS/measurements/mp25_3_onaxis.csv',15-1,0,[15-1,0,59397-1,1]);


hertzc26_thd_dB = csvread('./Input/TWEETERS/measurements/hertzc26_thd_dB.csv',6-1,0);
violino_thd_dB = csvread('./Input/TWEETERS/measurements/violino_thd_dB.csv',6-1,0);
et26_5_thd_dB = csvread('./Input/TWEETERS/measurements/et26_5_thd_dB.csv',6-1,0);
mp25_3_thd_dB = csvread('./Input/TWEETERS/measurements/mp25_3_thd_dB.csv',6-1,0);

X_tweet_onaxis = [hertzc26_onaxis(:,2),violino_onaxis(:,2),et26_5_onaxis(:,2),mp25_3_onaxis(:,2)];
X_tweet_thd = [hertzc26_thd_dB(:,2),violino_thd_dB(:,2),et26_5_thd_dB(:,2),mp25_3_thd_dB(:,2)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FURTHER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (discard phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% information)
freq_onaxis = CK165_onaxis(:,1);       %%%% Just to save one frequency axis vector which is the same for all
freq_thd = CK165_thd_dB(:,1);       %%%% Just to save one frequency axis vector which is the same for all

clearvars -except X_woof_onaxis X_woof_thd X_tweet_onaxis X_tweet_thd freq_onaxis freq_thd


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEATURE CALCULATIONS
% % (Exploit AUDIO TOOLBOX)
% % https://it.mathworks.com/help/audio/feature-extraction-and-deep-learning.html
% %%%%%% At the end of the process I should have in output 8 files:
% % 'X'
% % rows ---> speakers
% % columns ---> features 
% %
% %
% %
% %
% %%%%%%%%%%%%%% For each speaker in woofer
for i=1:4
    
clear X
    
                                            % decrease_ON_audiotoolbox = spectralDecrease(X_woof_onaxis(:,1),freq_onaxis);
                                            % centroid_ON_audio_toolbox = spectralCentroid(X_woof_onaxis(:,1),freq_onaxis);
decrease_ON = spec_decrease(X_woof_onaxis(:,i));
rolloff_ON = spectralRolloffPoint(X_woof_onaxis(:,i),freq_onaxis,'Threshold',0.85); 
centroid_ON = spec_centroid(X_woof_onaxis(:,i),freq_onaxis);
spread_ON = spectralSpread(X_woof_onaxis(:,i),freq_onaxis);
kurtosis_ON = spectralKurtosis(X_woof_onaxis(:,i),freq_onaxis);
entropy_ON = spectralEntropy(X_woof_onaxis(:,i),freq_onaxis,'SpectrumType','magnitude');
flatness_ON = spectralFlatness(X_woof_onaxis(:,i),freq_onaxis);
crest_ON = spectralCrest(X_woof_onaxis(:,i),freq_onaxis);
slope_ON = spectralSlope(X_woof_onaxis(:,i),freq_onaxis);
   spcontrast_ON = spec_contrast(X_woof_onaxis(:,i),freq_onaxis);
   AAD_ON = aad(X_woof_onaxis(:,i),freq_onaxis);
   envelope_thd = spec_envelope(X_woof_onaxis(:,i),freq_onaxis); 
flatness_thd = spectralFlatness(X_woof_thd(:,i),freq_thd);

%%%%%%%%%%%%%%%%%%% FOR ALL FEATURES OF THE AUDIOTOOLBOX IT HOLDS THE
%%%%%%%%%%%%%%%%%%% FOLLOWING
%%%% 'magnitude' type of spectrum is default option instead of power
%%%%
%%%% Then, for example:
%%%%
%%%% flatness = spectralFlatness(x,f)
%%%% If f is a vector, x is interpreted as a frequency-domain signal, 
%%%% and f is interpreted as the frequencies, in Hz, corresponding to the rows of x.

X_w(i,:) = [decrease_ON,rolloff_ON,centroid_ON,spread_ON,kurtosis_ON,entropy_ON,flatness_ON,...
    crest_ON,slope_ON,spcontrast_ON,AAD_ON,envelope_thd,flatness_thd];
    
% X_w(i,:) = [rolloff_ON,centroid_ON,spread_ON,kurtosis_ON,entropy_ON,flatness_ON,...
%     crest_ON,slope_ON,flatness_thd];

%       
%           switch i
%         case 1
%      save(['./Output/CK165' num2str(i) '.mat'],'X_w');
%         case 2
%      save(['./Output/thII' num2str(i) '.mat'],'X_w');
%         case 3
%      save(['./Output/ESK165' num2str(i) '.mat'],'X_w');
%         case 4
%      save(['./Output/MPK165' num2str(i) '.mat'],'X_w');
%     end
%
%
end
% %
% %
% %
% %
% %%%%%%%%%%%%%% For each speaker in tweeter
for i=1:4

    clear X
    
                                            % decrease_ON_audiotoolbox = spectralDecrease(X_woof_onaxis(:,1),freq);
                                            % centroid_ON_audio_toolbox = spectralCentroid(X_woof_onaxis(:,1),freq);
decrease_ON = spec_decrease(X_tweet_onaxis(:,i));
rolloff_ON = spectralRolloffPoint(X_tweet_onaxis(:,i),freq_onaxis,'Threshold',0.85); 
centroid_ON = spec_centroid(X_tweet_onaxis(:,i),freq_onaxis);
spread_ON = spectralSpread(X_tweet_onaxis(:,i),freq_onaxis);
kurtosis_ON = spectralKurtosis(X_tweet_onaxis(:,i),freq_onaxis);
entropy_ON = spectralEntropy(X_tweet_onaxis(:,i),freq_onaxis,'SpectrumType','magnitude');
flatness_ON = spectralFlatness(X_tweet_onaxis(:,i),freq_onaxis);
crest_ON = spectralCrest(X_tweet_onaxis(:,i),freq_onaxis);
slope_ON = spectralSlope(X_tweet_onaxis(:,i),freq_onaxis);
    spcontrast_ON = spec_contrast(X_tweet_onaxis(:,i),freq_onaxis);
    AAD_ON = aad(X_tweet_onaxis(:,i),freq_onaxis);
    envelope_thd = spec_envelope(X_tweet_onaxis(:,i),freq_onaxis); 
flatness_thd = spectralFlatness(X_woof_thd(:,i),freq_thd);

X_t(i,:) = [decrease_ON,rolloff_ON,centroid_ON,spread_ON,kurtosis_ON,entropy_ON,flatness_ON,...
    crest_ON,slope_ON,spcontrast_ON,AAD_ON,envelope_thd,flatness_thd];

% X_t(i,:) = [rolloff_ON,centroid_ON,spread_ON,kurtosis_ON,entropy_ON,flatness_ON,...
%     crest_ON,slope_ON,flatness_thd];

%       
%           switch i
%         case 1
%      save(['./Output/hertzc26' num2str(i) '.mat'],'X_t');
%         case 2
%      save(['./Output/violino' num2str(i) '.mat'],'X_t');
%         case 3
%      save(['./Output/et26_5' num2str(i) '.mat'],'X_t');
%         case 4
%      save(['./Output/mp25_3' num2str(i) '.mat'],'X_t');
%     end
%
  
    
    
end
 
        save(['./Output/X_woofer_training.mat'],'X_w');
        save(['./Output/X_tweeter_training.mat'],'X_t');
        
        save(['C:/Users/Alessio/Dropbox/Tesi Sopranzi/05__Algoritmo di learning/LEARNING/X/X_woofer_training.mat'],'X_w');
        save(['C:/Users/Alessio/Dropbox/Tesi Sopranzi/05__Algoritmo di learning/LEARNING/X/X_tweeter_training.mat'],'X_t');
        
        
clearvars -except X_w X_t
