clc
clear all
close all

ww = 35;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS
features  = ["AAD","LFX","LFQ","SM_ON","NBD"];

N_woofer = 35;
N_features = size(features,2);

X_w = zeros(N_woofer,size(features,1));  

%% GENERATE PREDICTED LPM RESPONSE


%%%%%% 
%%%%%% LOAD LPM PARAMETERS FOR ALL SPEAKERS
%%%%%% 
LPM = readmatrix('./Input/linear_parameters.csv','Range',[2 1]);
LPM = LPM(:,1:(end-1));             % Remove last column of NaN don't know why it appears

%%%% For each column a different linear parameter
% %
% %
%%% Store everything in separate variables for calculations
                                         % % 1)  S_d [cm^2]
S_D = LPM(:,2)';                         % % 2)  S_D[m^2]
R_es = LPM(:,3)';                        % % 3)  R_es [ohm]
C_mes = 10^(-6).*LPM(:,4)';              % % 4)  C_mes [muF]
L_ces = 10^(-3).*LPM(:,5)';              % % 5)  L_ces [mH]
L2 = 10^(-3).*LPM(:,6)';                % % 6)  L_2 [mH]
R2 = LPM(:,7)';                         % % 7)  R_2 [ohm]
Bl = LPM(:,8)';                          % % 8)  Bl [N/A]
LE = 10^(-3).*LPM(:,9)';                % % 9)  L_E[mH]
RE = LPM(:,10)';                        % % 10) R_E[ohm] 
v_corr_forFF = 1./LPM(:,11)';            % % 11) U_t LPM 1W/1m corr to TOT [Vrms] 

SQRT2 = sqrt(2);


rho = repmat(1.189,1,N_woofer);     % rho = 1.189 kg/m^3 (in Eq. 21) is the density of air @25°C
d=1; %[m]
COST_DEN = 2*pi.*d;
COST_NUM = S_D.* rho;
COST = COST_NUM./COST_DEN; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR EACH WOOFER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


freqHz = readmatrix('./Input/frequency_axis.csv');
freqHz = freqHz';

%             %%%%%%%%%%%% Just plot frequency behavior
%             freq_mean = mean(freqHz,1,'omitnan');
%             freq_mean = freq_mean(1:(end-5));
%             tempfig = figure;
%             plot(1:length(freq_mean),freq_mean);
%             grid on
%             xlabel('Frequency point');
%             ylabel('Frequency value [Hz]');
%             title('Average frequency resolution of measurements');
%             
%             print(tempfig,'MySavedPlot','-dpng')
%             close all
%             clearvars tempfig freq_mean

freqHz = freqHz(ww,:);    
freqHz = freqHz(~isnan(freqHz));            % remove strange NaNs
% dt = 1.6667*10^(-04);       % fictional sampling time
% f_s  = 1/dt;                % fictional sampling rate
% N = 2048;                   % fictional FFT length
% freqHz = 0:f_s/(N-1):f_s;
% %freqHz = linspace(0, f_s, length(U_w));
%%% GENERATE FREQUENCY AXIS LIKE
%%% KLIPPEL ANALYZER 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MECHANICAL TRANSFER FUNCTION

jw = 2*pi*freqHz*i;
jw = jw';
jw_pow2 = jw.*jw;
HxNUM = (jw.*L_ces(ww))./(jw_pow2.*L_ces(ww).*C_mes(ww) + jw.*(L_ces(ww)/R_es(ww))+1);  %Z_R
ZR = HxNUM;
ZP = (jw.*L2(ww).*R2(ww))./(jw.*L2(ww) + R2(ww));
HxDEN = (ZR+ZP+jw.*LE(ww)+RE(ww)).*(Bl(ww).*jw);

Hx = HxNUM./HxDEN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PRESSURE CALCULATION
% %
% %
U_w = 1;                    % assume white noise and SCALE DIRECTLY THIS WITH CORRECTION FACTOR
                            % we are reasoning already in f domain
% % 
% % Still linear here:
P_w = (jw_pow2).*(Hx).*(U_w).*(COST(ww));
P_w = P_w*SQRT2;
%P_w = P_w*LPM(ww,11);       % JUST TO COMPARE VISUALLY BUT FOR MERGING AT 1V!!

tol = 1e-5;         %% remove small amplitude transform noisy values
P_w(abs(P_w) < tol) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% MAGNITUDE AND PHASE
magnitude = abs(P_w);
P_magn = 20*log10(magnitude) - 20*log10(0.00002);           % dB transformation
P_phase = angle(P_w);
P_phase = rad2deg(P_phase);




% %%%%%%%%%%%%%%%%%%%%%%%%%% PLOT
% figure(1);
% semilogx(freqHz,P_magn);  % plot up to N/2 points to eliminate redundancy
% grid on
% %plot(freqHz,P_magn);
% xlabel('Frequency [Hz]');
% ylabel('|P(j\omega)| [dB]');
% title('Pressure magnitude spectrum') 
% 
% figure(2)
% %plot(freqHz,unwrap(rad2deg(P_phase)),'k');
% plot(freqHz,P_phase,'k');
% grid on
% xlabel('Frequency [Hz]');
% ylabel('\angle P(j\omega) [deg]');
% title('Pressure phase spectrum');
% 



%%%%%%% TO BE COMPARED WITH FAR-FIELD
%
% THE NEAR-FIELD STAYS THE SAME, THE FAR-FIELD HAS CORRECTION FACTOR
% APPLIED


%% FEATURE EXTRACTION
clearvars -except N_woofer
close all
clc

%
%%%%%
%%%%% WOOFERS (follow same order in measurements B001 | B002 | B003 | ... | B035 for columns)
%%%%% SAME FOR CORRESPONDING FREQ.AXIS
%
%
%%%%% READ CURVE AND FREQUENCY
X_magn = readmatrix('./Input/MERGED_curves.csv');
X_freq = readmatrix('./Input/MERGED_freq_axis.csv');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEATURE CALCULATIONS
% % (Exploit AUDIO TOOLBOX)
% % https://it.mathworks.com/help/audio/feature-extraction-and-deep-learning.html
% %%%%%% At the end of the process I should have in output a one file:
% % 'X_w'
% % rows ---> speakers (35)
% % columns ---> features (4)
% %
% %
% %%%%%%%%%%%%%% For each speaker in woofer
for i=1:N_woofer
    
clear X

X = X_magn(:,i);
X = X(~isnan(X));                                     % remove NaNs

%%%%%%%%%%%%%%%%% RETAIN X-AXIS OF SPECTRUM
freq_onaxis = X_freq(:,i);
freq_onaxis = freq_onaxis(~isnan(freq_onaxis));            % remove NaNs
    

AAD = aad(X,freq_onaxis);
[LFX_FREQ,IDX300,y_LW,LFX] = lfx(X,freq_onaxis);
LFQ = lfq(X,freq_onaxis,LFX,y_LW,IDX300,LFX_FREQ);
SM_ON = smoothness(X,freq_onaxis);
NBD = nbd(X,freq_onaxis);





    %%%% SAVE WITH WOOFERS ON ROW
X_w(i,:) = [AAD,LFX,LFQ,SM_ON,NBD]; % Must be a matrix 35x4


end
            %%%% SAVE .mat file
        save(['./Output/X_woofer__olive.mat'],'X_w');
 
            %%%% SAVE .xlsx file
        folder = 'C:\Users\Alessio\Dropbox\Tesi Sopranzi\REVERSE ENGINEERING\Feature extraction\Output';
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
        baseFileName = 'X_woofer__olive.xlsx';
        fullFileName = fullfile(folder, baseFileName);
        xlswrite(fullFileName ,X_w);

        

%% Feature extraction trial with 1/24 OUR REAL DATA

X_1_24= readmatrix('./Input/1_24_smoothed data/wooferI.csv');
X_2_24= readmatrix('./Input/1_24_smoothed data/wooferII.csv');
X_3_24= readmatrix('./Input/1_24_smoothed data/wooferIII.csv');
X_4_24= readmatrix('./Input/1_24_smoothed data/wooferIV.csv');

    %%%%% AAD
AAD_1 = aad(X_1_24(:,2),X_1_24(:,1));
AAD_2 = aad(X_2_24(:,2),X_2_24(:,1));
AAD_3 = aad(X_3_24(:,2),X_3_24(:,1));
AAD_4 = aad(X_4_24(:,2),X_4_24(:,1));

    %%%%% LFX and LFQ
[LFX_FREQ_1,IDX300_1,y_LW_1,LFX_1] = lfx(X_1_24(:,2),X_1_24(:,1));
LFQ_1 = lfq(X_1_24(:,2),X_1_24(:,1),LFX_1,y_LW_1,IDX300_1,LFX_FREQ_1);

[LFX_FREQ_2,IDX300_2,y_LW_2,LFX_2] = lfx(X_2_24(:,2),X_2_24(:,1));
LFQ_2 = lfq(X_2_24(:,2),X_2_24(:,1),LFX_2,y_LW_2,IDX300_2,LFX_FREQ_2);

[LFX_FREQ_3,IDX300_3,y_LW_3,LFX_3] = lfx(X_3_24(:,2),X_3_24(:,1));
LFQ_3 = lfq(X_3_24(:,2),X_3_24(:,1),LFX_3,y_LW_3,IDX300_3,LFX_FREQ_3);

[LFX_FREQ_4,IDX300_4,y_LW_4,LFX_4] = lfx(X_4_24(:,2),X_4_24(:,1));
LFQ_4 = lfq(X_4_24(:,2),X_4_24(:,1),LFX_4,y_LW_4,IDX300_4,LFX_FREQ_4);


NBD_1 = nbd(X_1_24(:,2),X_1_24(:,1));
NBD_2 = nbd(X_2_24(:,2),X_2_24(:,1));
NBD_3 = nbd(X_3_24(:,2),X_3_24(:,1));
NBD_4 = nbd(X_4_24(:,2),X_4_24(:,1));


SM_1 = smoothness(X_1_24(:,2),X_1_24(:,1));
SM_2 = smoothness(X_2_24(:,2),X_2_24(:,1));
SM_3 = smoothness(X_3_24(:,2),X_3_24(:,1));
SM_4 = smoothness(X_4_24(:,2),X_4_24(:,1));
