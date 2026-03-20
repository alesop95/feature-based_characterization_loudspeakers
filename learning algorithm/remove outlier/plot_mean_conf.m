% https://stackoverflow.com/questions/24908155/matlab-calculate-the-95-interval-around-the-mean
% https://github.com/JacobD10/SoundZone_Tools/blob/master/confidence_intervals.m
%%%%% https://it.mathworks.com/matlabcentral/answers/405089-reading-the-data-from-a-csv-file-with-headers

%%%% TO READ FROM TABLES
% Alternatively, you can recover the column associated with each header (column name) by using 
% ‘Properties.VariableNames’ to retrieve them. Then use strcmp to get the logical vector of 
% matching column names, and find to get the column number. :
%%% VarNames = Tbl.Properties.VariableNames;                      % Recover Variable Names (Column Titles)
%%% ColIdx = find(strcmp(VarNames, 'c'));                         % Return Column Index For Variable Name ‘c’
% Then use ‘ColIdx’ to access the column data in variable ‘c’.
% Experiment to get the result you want.


clear all
clc
close all

tweeter__attr1 = readtable('tweeter__attr1.csv');
tweeter__attr2 = readtable('tweeter__attr2.csv');
tweeter__attr3 = readtable('tweeter__attr3.csv');
woofer__attr1 = readtable('woofer__attr1.csv');
woofer__attr2 = readtable('woofer__attr2.csv');
woofer__attr3 = readtable('woofer__attr3.csv');
% cv = Tbl.SP1_TR1;    to retrieve data from table



%% Fill mean value matrix
%
%%%% x tracks data for plotting
x = [0.900000000000000,1.90000000000000,2.90000000000000;1,2,3;1.11111111111111,2.11111111111100,3.11111111000000;1.22222222200000,2.22222220000000,3.22222220000000];
%
%%%% MATRICE DEI VALORI MEDI DEI RATINGS SPEAKER - TRACCIA
y(1,1)=mean(tweeter__attr2.SP1_TR1);
y(1,2)=mean(tweeter__attr2.SP1_TR2);
y(1,3)=mean(tweeter__attr2.SP1_TR3);
y(2,1)=mean(tweeter__attr2.SP2_TR1);
y(2,2)=mean(tweeter__attr2.SP2_TR2);
y(2,3)=mean(tweeter__attr2.SP2_TR3);
y(3,1)=mean(tweeter__attr2.SP3_TR1);
y(3,2)=mean(tweeter__attr2.SP3_TR2);
y(3,3)=mean(tweeter__attr2.SP3_TR3);
y(4,1)=mean(tweeter__attr2.SP4_TR1);
y(4,2)=mean(tweeter__attr2.SP4_TR2);
y(4,3)=mean(tweeter__attr2.SP4_TR3);

%% Calculate confidence intervals
%%%%%%%%%%%% WITH OTHER VALUES BECAUSE SIMILI
% https://it.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval
%
% % % x is a vector, matrix, or any numeric array of data. NaNs are ignored.
% % % p is a the confident level (ie, 95 for 95% CI)
% % % The output is 1x2 vector showing the [lower,upper] interval values.
CIFcn = @(x,p)std(x(:),'omitnan')/sqrt(sum(~isnan(x(:)))) * tinv(abs([0,1]-(1-p/100)/2),sum(~isnan(x(:)))-1); %+ mean(x(:),'omitnan'); 
p = 95;

%%%% confidence speaker -traccia
conf_SP1_TR1 = CIFcn(tweeter__attr2.SP1_TR1,p);
conf_SP1_TR2 = CIFcn(tweeter__attr2.SP1_TR2,p);
conf_SP1_TR3 = CIFcn(tweeter__attr2.SP1_TR3,p);
conf_SP2_TR1 = CIFcn(tweeter__attr2.SP2_TR1,p);
conf_SP2_TR2 = CIFcn(tweeter__attr2.SP2_TR2,p);
conf_SP2_TR3 = CIFcn(tweeter__attr2.SP2_TR3,p);
conf_SP3_TR1 = CIFcn(tweeter__attr2.SP3_TR1,p);
conf_SP3_TR2 = CIFcn(tweeter__attr2.SP3_TR2,p);
conf_SP3_TR3 = CIFcn(tweeter__attr2.SP3_TR2,p);
conf_SP4_TR1 = CIFcn(tweeter__attr2.SP4_TR1,p);
conf_SP4_TR2 = CIFcn(tweeter__attr2.SP4_TR2,p);
conf_SP4_TR3 = CIFcn(tweeter__attr2.SP4_TR3,p);

%% Plot

%%% lower confidence interval 
conf_A_lower =[conf_SP1_TR1(1)    conf_SP1_TR2(1)   conf_SP1_TR3(1)];
conf_B_lower =[conf_SP2_TR1(1)    conf_SP2_TR2(1)   conf_SP2_TR3(1)];
conf_C_lower =[conf_SP3_TR1(1)    conf_SP3_TR2(1)   conf_SP3_TR3(1)];
conf_D_lower =[conf_SP4_TR1(1)    conf_SP4_TR2(1)   conf_SP4_TR3(1)];
conf_ABCD_lower = [conf_A_lower; conf_B_lower; conf_C_lower; conf_D_lower];

%%% upper confidence interval
conf_A_upper =[conf_SP1_TR1(2)    conf_SP1_TR2(2)    conf_SP1_TR3(2)];
conf_B_upper =[conf_SP2_TR1(2)    conf_SP2_TR2(2)    conf_SP2_TR3(2)];
conf_C_upper =[conf_SP3_TR1(2)    conf_SP3_TR2(2)    conf_SP3_TR3(2)];
conf_D_upper =[conf_SP4_TR1(2)    conf_SP4_TR2(2)    conf_SP4_TR3(2)];
conf_ABCD_upper = [conf_A_upper; conf_B_upper; conf_C_upper; conf_D_upper];

% errorbar(x,y,yneg,ypos,xneg,xpos,'o')
%%% confidence interval setto dopo

figure
hold on
errorbar(x(1,:), y(1,:), conf_ABCD_lower(1,:), conf_ABCD_upper(1,:), '.r')   % plotto primo valore a sinistra per 1x,2x,3x                               
errorbar(x(2,:), y(2,:), conf_ABCD_lower(2,:), conf_ABCD_upper(2,:), 'o')        
errorbar(x(3,:), y(3,:), conf_ABCD_lower(3,:), conf_ABCD_upper(3,:), 'v') 
errorbar(x(4,:), y(4,:), conf_ABCD_lower(4,:), conf_ABCD_upper(4,:), '^')  


xlabel('Tracks','Interpreter','Latex')
ylabel('Mean Preference','interpreter','latex')
ylim([0 1])
hold off


legend({'Speaker 1', 'Speaker 2','Speaker 3','Speaker 4'},'Interpreter','Latex','Location','northwest')
%title('Woofers, Timbral Balance 95% Confidence Intervals','Interpreter','Latex');


