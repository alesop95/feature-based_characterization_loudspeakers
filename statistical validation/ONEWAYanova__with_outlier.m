%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   ONE WAY ANOVA                           %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ATTRIBUTE 1 = LOUDNESS
% ATTRIBUTE 2 = TIMBRAL BALANCE
% ATTRIBUTE 3 = PREFERENCE

%% RE-FRAME THE DATASET

mask = zeros(1,tot_combinations)
for ii=1:3:tot_combinations
mask(ii)= 1;
end
mask = logical(mask)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO ATTRIBUTO 1 
mask = circshift(mask,0);

woofer_oneway_attr1 = results_woofer(:,mask);
tweeter_oneway_attr1 = results_tweeter(:,mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO ATTRIBUTO 2
mask = circshift(mask,1);

woofer_oneway_attr2 = results_woofer(:,mask);
tweeter_oneway_attr2 = results_tweeter(:,mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO ATTRIBUTO 3 
% PROCEDURAL CODE! ALREADY SHIFTED BY ONE!
mask = circshift(mask,1);
 
woofer_oneway_attr3 = results_woofer(:,mask);
tweeter_oneway_attr3 = results_tweeter(:,mask);

%%%%%%%%%%%%%%%%%%%%%%          EXPORT  (transpose to group by
%%%%%%%%%%%%%%%%%%%%%%          listeners, here in rows so transpose)

csvwrite('woofer_oneway_attr1.csv',woofer_oneway_attr1')
filename = 'woofer_oneway_attr1.xlsx';
writematrix(woofer_oneway_attr1',filename,'Sheet',1);

csvwrite('tweeter_oneway_attr1.csv',tweeter_oneway_attr1')
filename = 'tweeter_oneway_attr1.xlsx';
writematrix(tweeter_oneway_attr1',filename,'Sheet',1);

csvwrite('woofer_oneway_attr2.csv',woofer_oneway_attr2')
filename = 'woofer_oneway_attr2.xlsx';
writematrix(woofer_oneway_attr2',filename,'Sheet',1);

csvwrite('tweeter_oneway_attr2.csv',tweeter_oneway_attr2')
filename = 'tweeter_oneway_attr2.xlsx';
writematrix(tweeter_oneway_attr2',filename,'Sheet',1);

csvwrite('woofer_oneway_attr3.csv',woofer_oneway_attr3')
filename = 'woofer_oneway_attr3.xlsx';
writematrix(woofer_oneway_attr3',filename,'Sheet',1);

csvwrite('tweeter_oneway_attr3.csv',tweeter_oneway_attr3')
filename = 'tweeter_oneway_attr3.xlsx';
writematrix(tweeter_oneway_attr3',filename,'Sheet',1);

clear mask ii shift

%%% SAVE BEFORE PERFORMING ANOVA
save('workspace_base')

%% PERFORM ONE-WAY ANOVA FOR EACH ATTRIBUTE
%
%

Listeners = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};

% https://it.mathworks.com/help/matlab/ref/sgtitle.html
%%%%% WOOFERS
[~,tbl_woofer_attr1,stats_woofer_attr1] = anova1(woofer_oneway_attr1',Listeners,'off');
[~,tbl_woofer_attr2,stats_woofer_attr2] = anova1(woofer_oneway_attr2',Listeners,'off');
[~,tbl_woofer_attr3,stats_woofer_attr3] = anova1(woofer_oneway_attr3',Listeners,'off');

woofer_attr1_table = cell2table(tbl_woofer_attr1);
woofer_attr2_table = cell2table(tbl_woofer_attr2);
woofer_attr3_table = cell2table(tbl_woofer_attr3);

figure()
uitable('Data',woofer_attr1_table{:,:},...
    'RowName',woofer_attr1_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
figure()
uitable('Data',woofer_attr2_table{:,:},...
    'RowName',woofer_attr2_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
figure()
uitable('Data',woofer_attr3_table{:,:},...
    'RowName',woofer_attr3_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);




figure(1)
subplot(3,1,1)
    boxplot(woofer_oneway_attr1',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Woofer ratings, Attribute 1','Fontsize',10,'Fontweight','bold')
    ylabel('Loudness','Fontsize',10,'Fontweight','bold')
subplot(3,1,2)
    boxplot(woofer_oneway_attr2',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Woofer ratings, Attribute 2','Fontsize',10,'Fontweight','bold')
    ylabel('Timbral Balance','Fontsize',10,'Fontweight','bold')
subplot(3,1,3)
    boxplot(woofer_oneway_attr3',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Woofer ratings, Attribute 3','Fontsize',10,'Fontweight','bold')
    ylabel('Preference','Fontsize',10,'Fontweight','bold')
sgtitle('Woofer ratings')

%%%%% TWEETERS
[~,tbl_tweeter_attr1,stats_tweeter_attr1] = anova1(tweeter_oneway_attr1',Listeners,'off');
[~,tbl_tweeter_attr2,stats_tweeter_attr2] = anova1(tweeter_oneway_attr2',Listeners,'off');
[~,tbl_tweeter_attr3,stats_tweeter_attr3] = anova1(tweeter_oneway_attr3',Listeners,'off');

tweeter_attr1_table = cell2table(tbl_tweeter_attr1);
tweeter_attr2_table = cell2table(tbl_tweeter_attr2);
tweeter_attr3_table = cell2table(tbl_tweeter_attr3);

figure()
uitable('Data',tweeter_attr1_table{:,:},...
    'RowName',tweeter_attr1_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
figure()
uitable('Data',tweeter_attr2_table{:,:},...
    'RowName',tweeter_attr2_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
figure()
uitable('Data',tweeter_attr3_table{:,:},...
    'RowName',tweeter_attr3_table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);


figure(2)
subplot(3,1,1)
    boxplot(tweeter_oneway_attr1',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Tweeter ratings, Attribute 1','Fontsize',10,'Fontweight','bold')
    ylabel('Loudness','Fontsize',10,'Fontweight','bold')
subplot(3,1,2)
    boxplot(tweeter_oneway_attr2',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Tweeter ratings, Attribute 2','Fontsize',10,'Fontweight','bold')
    ylabel('Timbral Balance','Fontsize',10,'Fontweight','bold')
subplot(3,1,3)
    boxplot(tweeter_oneway_attr3',Listeners,'notch','on')
    ylim([0 1])
    xlabel('Listener number','Fontsize',10,'Fontweight','bold')
    %ylabel('Tweeter ratings, Attribute 3','Fontsize',10,'Fontweight','bold')
    ylabel('Preference','Fontsize',10,'Fontweight','bold')
sgtitle('Tweeter ratings')

%
%
%
%%%%%%%%%%%%%%%%%%%%%% CHECK CRITICAL VALUE FOR F-value (SET 95% as 5%
%%%%%%%%%%%%%%%%%%%%%% confidence ON P-VALUE!!!)
% second and third arguments degree of freedoms!!
crit_F_woofer_attr1 = finv(0.95,tbl_woofer_attr1{2,3},tbl_woofer_attr1{3,3});
crit_F_woofer_attr2 = finv(0.95,tbl_woofer_attr2{2,3},tbl_woofer_attr2{3,3});
crit_F_woofer_attr1 = finv(0.95,tbl_woofer_attr3{2,3},tbl_woofer_attr3{3,3});
crit_F_tweeter_attr1 = finv(0.95,tbl_tweeter_attr1{2,3},tbl_tweeter_attr1{3,3});
crit_F_tweeter_attr2 = finv(0.95,tbl_tweeter_attr2{2,3},tbl_tweeter_attr2{3,3});
crit_F_tweeter_attr3 = finv(0.95,tbl_tweeter_attr3{2,3},tbl_tweeter_attr3{3,3});
%
%%%% ALWAYS THE SAME! (1.7521) because always same degrees of freedoms 

%% PERFORM TUKEY'S HONESTLY SIGNIFICANT DIFFERENCE (HSD)
[c_woofer1,m_woofer1] = multcompare(stats_woofer_attr1,'CType','hsd');
[c_woofer2,m_woofer2] = multcompare(stats_woofer_attr2,'CType','hsd');
[c_woofer3,m_woofer3] = multcompare(stats_woofer_attr3,'CType','hsd');

[c_tweeter1,m_tweeter1] = multcompare(stats_tweeter_attr1,'CType','hsd');
[c_tweeter2,m_tweeter2] = multcompare(stats_tweeter_attr2,'CType','hsd');
[c_tweeter3,m_tweeter3] = multcompare(stats_tweeter_attr3,'CType','hsd');

% Matrix of multiple comparison results, returned as an p-by-6 matrix of scalar values, 
% where p is the number of pairs of groups. Each row of the matrix contains the result of one paired comparison test.
% Columns 1 and 2 contain the indices of the two samples being compared. 
% Column 3 contains the lower confidence interval, 
% column 4 contains the estimate
% Column 5 contains the upper confidence interval. 
% Column 6 contains the p-value for the hypothesis test that the corresponding mean difference is not equal to 0.

%% DESCRIPTIVE TEST/STATISTICS (Testing assumptions of ANOVA and TUKEY HSD test)

% Check for [bech2006]Pag.165 on:
% 1. Indipendence of observations
% 2. Homogeneity of variance across tested combinations of independent
% variables (here group = listener)
% 3. Normal distribution of repeated observations
% 4. Detection of outliers

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1. Indipendence of observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% controlled by means of STATISTICAL EXPERIMENTAL DESIGN (LATINSQUARE)




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2. Homogeneity of variance across tested combinations of independent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% variables (here group = listener) -> how much population variances in each group are equal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%% USE BARTLETT AND LEVENE TEST  
% https://it.mathworks.com/help/stats/vartestn.html

%
% Bartlett test of the null hypothesis that the columns of data vector x come from normal distributions with 
% the same variance. The alternative hypothesis is that not all columns of data have the same variance.
%
% The low p-value, p = 0, indicates that vartestn rejects the null hypothesis that the variances are equal across 
% all five columns, in favor of the alternative hypothesis that at least one column has a different variance.
% low p-value ->  at least one column has a different variance.
% high p-value -> all variances are ~equal (across listeners in this case)
%
%%%%%% WOOFER 
[p_var_woofer_1_bart]= vartestn(woofer_oneway_attr1,'TestType','Bartlett','Display','off');
[p_var_woofer_1_lev] = vartestn(woofer_oneway_attr1,'TestType','LeveneAbsolute','Display','off');

[p_var_woofer_2_bart] = vartestn(woofer_oneway_attr2,'TestType','Bartlett','Display','off');
[p_var_woofer_2_lev] = vartestn(woofer_oneway_attr2,'TestType','LeveneAbsolute','Display','off');

[p_var_woofer_3_bart] = vartestn(woofer_oneway_attr3,'TestType','Bartlett','Display','off');
[p_var_woofer_3_lev] = vartestn(woofer_oneway_attr3,'TestType','LeveneAbsolute','Display','off');


%%%%%% TWEETERS
[p_var_tweeter_1_bart] = vartestn(tweeter_oneway_attr1,'TestType','Bartlett','Display','off');
[p_var_tweeter_1_lev] = vartestn(tweeter_oneway_attr1,'TestType','LeveneAbsolute','Display','off');

[p_var_tweeter_2_bart] = vartestn(tweeter_oneway_attr2,'TestType','Bartlett','Display','off');
[p_var_tweeter_2_lev] = vartestn(tweeter_oneway_attr2,'TestType','LeveneAbsolute','Display','off');

[p_var_tweeter_3_bart] = vartestn(tweeter_oneway_attr3,'TestType','Bartlett','Display','off');
[p_var_tweeter_3_lev] = vartestn(tweeter_oneway_attr3,'TestType','LeveneAbsolute','Display','off');

array = [p_var_woofer_1_bart,p_var_woofer_1_lev,p_var_woofer_2_bart,p_var_woofer_2_lev,p_var_woofer_3_bart,p_var_woofer_3_lev,...
    p_var_tweeter_1_bart,p_var_tweeter_1_lev,p_var_tweeter_2_bart,p_var_tweeter_2_lev,p_var_tweeter_3_bart,p_var_tweeter_3_lev];

clc

if all(array >= 0.05)
    disp("Homogeneity of variance test passed")
end
  
clearvars p_var_woofer_1_bart p_var_woofer_1_lev p_var_woofer_2_bart p_var_woofer_2_lev p_var_woofer_3_bart p_var_woofer_3_lev...
    p_var_tweeter_1_bart p_var_tweeter_1_lev p_var_tweeter_2_bart p_var_tweeter_2_lev p_var_tweeter_3_bart p_var_tweeter_3_lev


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3. Normal distribution of repeated observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The distribution of the original data, for say a group of 15 listeners, will be determined by the 15 mean values
% and can or should not be normally distributed, but the repeated ratings
% for each listener should be [bech2006]
%
% The dependent variable is normally distributed in each group that is being compared in the one-way ANOVA 
%(technically, it is the residuals that need to be normally distributed, but the results will be the same).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WOOFER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%% GRAPHIC ASSESSMENT
%
%
%%% Histograms (NOT SO USEFUL WITH SMALL SAMPLE DATA)
% for jj=1:tot_subj
%     figure()
% histogram(woofer_oneway_attr1(jj,:),100)
% end
% %(...)
%
%%% QQ plots
for kk=1:tot_subj
    figure()
qqplot(woofer_oneway_attr1(kk,:))
end

for kk=1:tot_subj
    figure()
qqplot(woofer_oneway_attr2(kk,:))
end

for kk=1:tot_subj
    figure()
qqplot(woofer_oneway_attr3(kk,:))
end

%
%
%%% Box-plots
% (SEE ANOVA results)

%
%%% Skewness and kurtosis 
%
% The normal distribution has a skewness of zero and kurtosis of three.  
% A test is based on the difference between the data's skewness and zero and the data's kurtosis and three.
SKEW_woof_1 = zeros(1,tot_subj);
KURT_woof_1 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_woof_1(pp)=skewness(woofer_oneway_attr1(pp,:));
KURT_woof_1(pp)=kurtosis(woofer_oneway_attr1(pp,:));
end
disp(SKEW_woof_1)
disp(KURT_woof_1)

SKEW_woof_2 = zeros(1,tot_subj);
KURT_woof_2 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_woof_2(pp)=skewness(woofer_oneway_attr2(pp,:));
KURT_woof_2(pp)=kurtosis(woofer_oneway_attr2(pp,:));
end
disp(SKEW_woof_2)
disp(KURT_woof_2)

SKEW_woof_3 = zeros(1,tot_subj);
KURT_woof_3 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_woof_3(pp)=skewness(woofer_oneway_attr3(pp,:));
KURT_woof_3(pp)=kurtosis(woofer_oneway_attr3(pp,:));
end
disp(SKEW_woof_3)
disp(KURT_woof_3)

%%%%%%%%%%%%%%%%%% STATISTICAL ASSESSMENT
% Cite:
% Ipek (2020). Normality test package (https://www.mathworks.com/matlabcentral/fileexchange/60147-normality-test-package), MATLAB Central File Exchange. Retrieved February 5, 2020.
%
% Results fr Shapiro-Wilk test is on (7,3) of Results matrix for each group
% being compared
Cell_woofer = cell(1,tot_subj);
normality_check_woofer_SW = zeros(1,tot_subj);
normality_check_woofer_SF = zeros(1,tot_subj);
normality_check_woofer_AD = zeros(1,tot_subj);
normality_check_woofer_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_woofer{ii} = normalitytest(woofer_oneway_attr1(ii,:));
normality_check_woofer_SW(1,ii) = Cell_woofer{ii}(7,3);
normality_check_woofer_SF(1,ii) = Cell_woofer{ii}(8,3);
normality_check_woofer_AD(1,ii) = Cell_woofer{ii}(5,3);
normality_check_woofer_JB(1,ii) = Cell_woofer{ii}(9,3);
end
disp(normality_check_woofer_SW)
disp(normality_check_woofer_SF)
disp(normality_check_woofer_AD)
disp(normality_check_woofer_JB)



Cell_woofer = cell(1,tot_subj);
normality_check_woofer_SW = zeros(1,tot_subj);
normality_check_woofer_SF = zeros(1,tot_subj);
normality_check_woofer_AD = zeros(1,tot_subj);
normality_check_woofer_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_woofer{ii} = normalitytest(woofer_oneway_attr2(ii,:));
normality_check_woofer_SW(1,ii) = Cell_woofer{ii}(7,3);
normality_check_woofer_SF(1,ii) = Cell_woofer{ii}(8,3);
normality_check_woofer_AD(1,ii) = Cell_woofer{ii}(5,3);
normality_check_woofer_JB(1,ii) = Cell_woofer{ii}(9,3);
end
disp(normality_check_woofer_SW)
disp(normality_check_woofer_SF)
disp(normality_check_woofer_AD)
disp(normality_check_woofer_JB)



Cell_woofer = cell(1,tot_subj);
normality_check_woofer_SW = zeros(1,tot_subj);
normality_check_woofer_SF = zeros(1,tot_subj);
normality_check_woofer_AD = zeros(1,tot_subj);
normality_check_woofer_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_woofer{ii} = normalitytest(woofer_oneway_attr3(ii,:));
normality_check_woofer_SW(1,ii) = Cell_woofer{ii}(7,3);
normality_check_woofer_SF(1,ii) = Cell_woofer{ii}(8,3);
normality_check_woofer_AD(1,ii) = Cell_woofer{ii}(5,3);
normality_check_woofer_JB(1,ii) = Cell_woofer{ii}(9,3);
end
disp(normality_check_woofer_SW)
disp(normality_check_woofer_SF)
disp(normality_check_woofer_AD)
disp(normality_check_woofer_JB)

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TWEETER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%% GRAPHIC ASSESSMENT
%
%
%%% Histograms (NOT SO USEFUL WITH SMALL SAMPLE DATA)

%(...)
%
%%% QQ plots
%
for kk=1:tot_subj
    figure()
qqplot(tweeter_oneway_attr1(kk,:))
end

for kk=1:tot_subj
    figure()
qqplot(tweeter_oneway_attr2(kk,:))
end

for kk=1:tot_subj
    figure()
qqplot(tweeter_oneway_attr3(kk,:))
end

%
%
%%% Box-plots
% (SEE ANOVA results)

%
%%% Skewness and kurtosis 
%

SKEW_tweet_1 = zeros(1,tot_subj);
KURT_tweet_1 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_tweet_1(pp)=skewness(tweeter_oneway_attr1(pp,:));
KURT_tweet_1(pp)=kurtosis(tweeter_oneway_attr1(pp,:));
end
disp(SKEW_tweet_1)
disp(KURT_tweet_1)

SKEW_tweet_2 = zeros(1,tot_subj);
KURT_tweet_2 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_tweet_2(pp)=skewness(tweeter_oneway_attr2(pp,:));
KURT_tweet_2(pp)=kurtosis(tweeter_oneway_attr2(pp,:));
end
disp(SKEW_tweet_2)
disp(KURT_tweet_2)

SKEW_tweet_3 = zeros(1,tot_subj);
KURT_tweet_3 = zeros(1,tot_subj);
for pp=1:tot_subj
SKEW_tweet_3(pp)=skewness(tweeter_oneway_attr3(pp,:));
KURT_tweet_3(pp)=kurtosis(tweeter_oneway_attr3(pp,:));
end
disp(SKEW_tweet_3)
disp(KURT_tweet_3)


%%%%%%%%%%%%%%%%%% STATISTICAL ASSESSMENT
% Cite:
% Ipek (2020). Normality test package (https://www.mathworks.com/matlabcentral/fileexchange/60147-normality-test-package), MATLAB Central File Exchange. Retrieved February 5, 2020.
%
% Results fr Shapiro-Wilk test is on (7,3) of Results matrix for each group
% being compared
Cell_tweeter = cell(1,tot_subj);
normality_check_tweeter_SW = zeros(1,tot_subj);
normality_check_tweeter_SF = zeros(1,tot_subj);
normality_check_tweeter_AD = zeros(1,tot_subj);
normality_check_tweeter_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_tweeter{ii} = normalitytest(tweeter_oneway_attr1(ii,:));
normality_check_tweeter_SW(1,ii) = Cell_tweeter{ii}(7,3);
normality_check_tweeter_SF(1,ii) = Cell_tweeter{ii}(8,3);
normality_check_tweeter_AD(1,ii) = Cell_tweeter{ii}(5,3);
normality_check_tweeter_JB(1,ii) = Cell_tweeter{ii}(9,3);
end
disp(normality_check_tweeter_SW)
disp(normality_check_tweeter_SF)
disp(normality_check_tweeter_AD)
disp(normality_check_tweeter_JB)


Cell_tweeter = cell(1,tot_subj);
normality_check_tweeter_SW = zeros(1,tot_subj);
normality_check_tweeter_SF = zeros(1,tot_subj);
normality_check_tweeter_AD = zeros(1,tot_subj);
normality_check_tweeter_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_tweeter{ii} = normalitytest(tweeter_oneway_attr2(ii,:));   %% FAILS ON ROW 12!!! for shapiro wilk
normality_check_tweeter_SW(1,ii) = Cell_tweeter{ii}(7,3);
normality_check_tweeter_SF(1,ii) = Cell_tweeter{ii}(8,3);
normality_check_tweeter_AD(1,ii) = Cell_tweeter{ii}(5,3);
normality_check_tweeter_JB(1,ii) = Cell_tweeter{ii}(9,3);
end
disp(normality_check_tweeter_SW)
disp(normality_check_tweeter_SF)
disp(normality_check_tweeter_AD)
disp(normality_check_tweeter_JB)



Cell_tweeter = cell(1,tot_subj);
normality_check_tweeter_SW = zeros(1,tot_subj);
normality_check_tweeter_SF = zeros(1,tot_subj);
normality_check_tweeter_AD = zeros(1,tot_subj);
normality_check_tweeter_JB = zeros(1,tot_subj);
for ii=1:tot_subj
Cell_tweeter{ii} = normalitytest(tweeter_oneway_attr3(ii,:));
normality_check_tweeter_SW(1,ii) = Cell_tweeter{ii}(7,3);
normality_check_tweeter_SF(1,ii) = Cell_tweeter{ii}(8,3);
normality_check_tweeter_AD(1,ii) = Cell_tweeter{ii}(5,3);
normality_check_tweeter_JB(1,ii) = Cell_tweeter{ii}(9,3);
end
disp(normality_check_tweeter_SW)
disp(normality_check_tweeter_SF)
disp(normality_check_tweeter_AD)
disp(normality_check_tweeter_JB)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4. Detection of outliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use the BOX PLOT as a further aid

