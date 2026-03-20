clear all
clc
close all

N_ATTR = 3;
N_SPEAK = 4;
N_TRACKS = 3;
N_SUBJECTS = 15;

%  FEATURE_EXTRACTED_NAMES  = ["decrease_ON","rolloff_ON","centroid_ON","spread_ON","kurtosis_ON", ...
%     "entropy_ON","flatness_ON","crest_ON","slope_ON","spcontrast_ON",...
%     "AAD_ON","envelope_thd", "flatness_thd"];

%
%
%
%  FEATURE_EXTRACTED_NAMES  = ["rolloff_ON","centroid_ON","spread_ON","kurtosis_ON", ...
%     "entropy_ON","flatness_ON","crest_ON","slope_ON", "flatness_thd"];


%% GENERATE FAKE X OBJECTIVE DATA (ALREADY NORMALIZED BETWEEN 0 AND 1)
%(assume 4 rows)
%


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ADD TRACK AS REPLICATE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ON X
% %
% rng(0,'twister');
% a = 0;
% b = 1;
% row1 = ((b-a).*rand(59,1) + a)';
% row2 = ((b-a).*rand(59,1) + a)';
% row3 = ((b-a).*rand(59,1) + a)';
% row4 = ((b-a).*rand(59,1) + a)';
% Xtrain_woofers = [row1;row2;row3;row4];
% 
% clear row1 row2 row3 row4
%
% % % Create replicate with appended at the end the number of track (as a
% % % further feature)
% Xtrain_woofers = [repmat(Xtrain_woofers(1,:),N_TRACKS,1);repmat(Xtrain_woofers(2,:),3,1);...
%     repmat(Xtrain_woofers(3,:),N_TRACKS,1);repmat(Xtrain_woofers(4,:),N_TRACKS,1)];
% append = [1;2;3;1;2;3;1;2;3;1;2;3];
% 
% Xtrain_woofers = [Xtrain_woofers,append];
% 
% clear append

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETELY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RANDOM
% 
% rng(0,'twister');
% a = 0;
% b = 1;
% row1 = ((b-a).*rand(59,1) + a)';
% row2 = ((b-a).*rand(59,1) + a)';
% row3 = ((b-a).*rand(59,1) + a)';
% row4 = ((b-a).*rand(59,1) + a)';
% row5 = ((b-a).*rand(59,1) + a)';
% row6 = ((b-a).*rand(59,1) + a)';
% row7 = ((b-a).*rand(59,1) + a)';
% row8 = ((b-a).*rand(59,1) + a)';
% row9 = ((b-a).*rand(59,1) + a)';
% row10 = ((b-a).*rand(59,1) + a)';
% row11= ((b-a).*rand(59,1) + a)';
% row12 = ((b-a).*rand(59,1) + a)';
% Xtrain_woofers = [row1;row2;row3;row4;row5;row6;row7;row8;row9;row10;row11;row12];
% clear row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ARTIFICIAL CORRELATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ON ROWS FOR TRACKS AND
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% APPEND TRACK NUMBER
rng(0,'twister');
a = 0;
b = 1;
non_COPIEDROWS = 40;
%%%%%%%%%% Copy first N_FEATURES - n_COPIEDROWS rows 
row1 = ((b-a).*rand(59,1) + a)';
row2 = [row1(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row3 = [row1(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row4 = ((b-a).*rand(59,1) + a)';
row5 = [row4(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row6 = [row4(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row7 = ((b-a).*rand(59,1) + a)';
row8 = [row7(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row9 = [row7(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row10 = ((b-a).*rand(59,1) + a)';
row11= [row10(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
row12 = [row10(1:59-non_COPIEDROWS),((b-a).*rand(non_COPIEDROWS,1) + a)'];
Xtrain_woofers = [row1;row2;row3;row4;row5;row6;row7;row8;row9;row10;row11;row12];
clear row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12
% % Create replicate with appended at the end the number of track (as a
% % further feature)
append = [0;0.5;1;0;0.5;1;0;0.5;1;0;0.5;1];
Xtrain_woofers = [Xtrain_woofers,append];

clear append


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGN LABELS
% %
% %


%%  GENERATE FAKE X SUBJECTIVE DATA (ALREADY NORMALIZED BETWEEN 0 AND 1)
%
% SP1_TR1,SP1_TR2,SP1_TR3,SP2_TR1,SP2_TR2,SP2_TR3,SP3_TR1,SP3_TR2,SP3_TR3,SP4_TR1,SP4_TR2,SP4_TR3
%

WOOF_ratings_attr1 = (b-a).*rand(15,12)+a;
WOOF_ratings_attr2 = (b-a).*rand(15,12)+a;
WOOF_ratings_attr3 = (b-a).*rand(15,12)+a;

Y_3WAY_WOOF = cat(3,WOOF_ratings_attr1',WOOF_ratings_attr2',WOOF_ratings_attr3');
%%%% PERMUTE 3WAY structure with each slice |/ is for a particular attribute and 
%%%% in each diagonal slice |||rows = speaker/track ratings and /// columns = listeners
Y_3WAY_WOOF = permute(Y_3WAY_WOOF,[1 3 2]);

clear WOOF_ratings_attr1 WOOF_ratings_attr2 WOOF_ratings_attr3


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Normalization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %
% % % % FEATURE NORMALIZATION
% % % % The features are very different each other, and the values can be in very
% % % % different ranges!!! What we deal with feature is to build the geometrical
% % % % space, and we wanna dimension to be coherent in range. We need to do
% % % % normalization over the ROWS (in order to rearrange all of ROWS in
% % % % dataset from a range of 0 to 1) 
% % % % Normalize the LLFs (rearrange all rows of dataset between 0 and 1) 
% Xtrain_woofers = (Xtrain_woofers - min(Xtrain_woofers))./(max(Xtrain_woofers) - min(Xtrain_woofers));
%                     % % % otherwise, the same:
%                     % normCoef = max(Xtrain_woofers)
%                     % Xtrain_woofers = Xtrain_woofers./repmat(normCoef, [size(Xtrain_woofers,1) 1]);
%                     % % %
%                     % 


%% ASSUMPTION CHECK 
%
%
%%%% MULTICOLLINEARITY
%
% (method1)
% https://www.statisticssolutions.com/wp-content/uploads/wp-post-to-pdf-enhanced-cache/1/assumptions-of-multiple-linear-regression.pdf
% R = corrcoef(Xtrain_woofers);
%     %%%% Set a threshold of acceptability
% outl = abs(R)>.8;
% outl = tril(outl);
% outl = outl - eye(size(R,1));
%  cols_with_all_zeros = find(all(outl==0)); % all zeros
% Xtrain_woofers = Xtrain_woofers(:,cols_with_all_zeros);
%
% (method2)
% From [Science2010] Chapter 15
% The collinearity problem is most often diagnosed by looking at the eigenvalue structure (see Chapter14) 
% of the matrix X^TX which is the same as investigating the explained variances of the different components 
% in a PCA of the matrix X. If the largest eigenvalue is much larger than the smaller ones, there is 
% collinearity in the data, i.e. the variance in the directions with the largest variability is much larger 
% than the variance in the directions with small or moderate variability
% X_TX = Xtrain_woofers'*Xtrain_woofers;
% e = eig(X_TX);
% diff_eig = abs(e - max(e));

%
%%%% REMOVING OUTLIERS IN TERMS OF VARIANCE (if zscore goes too much away
%%%% from mean value)
% Xtrain_woofers = zscore(Xtrain_woofers);
% cols_with_all_zeros = find(all(outl==0));





% % % % %% %% %% %% %% %% %% %% %% %% %% %% %% % % % %
% % % % %% %% %% %% %% %% %% %% %% %% %% %% %% % % % % 
% % % % %%                                  %% % % % % 
% % %                                            % % %  
% %%   TRAINING THE MODEL FOR EACH ATTRIBUTE    %% % %
% % %                                            % % %
% % % % %%                                  %% % % % %
% % % % %% %% %% %% %% %% %% %% %% %% %% %% %% % % % % 
% % % % %% %% %% %% %% %% %% %% %% %% %% %% %% % % % %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MULTIVARIATE LINEAR REGRESSION (for each attribute)
% %
% % https://web.stanford.edu/~mrosenfe/soc_meth_proj3/soc_180B_regression_whatchanges.htm
% %
% % % % %%
% % % % %%
% % % https://www.mathworks.com/help/stats/linearmodel.html
% % % % %%
% % % % %%
% %training and testing a different model and feature set for each ATTRIBUTE
% % % % 
% % % %
% %% SOLUZIONE (I)
% %
% %
for attr = 1:N_ATTR 
    
 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SPLIT TRAIN AND TEST DATA
    perc_train      = 0.7;
    %%%% The whole data where again each column is
    %%%% SP1_TR1,SP1_TR2,SP1_TR3,SP2_TR1,SP2_TR2,SP2_TR3,SP3_TR1,SP3_TR2,SP3_TR3,SP4_TR1,SP4_TR2,SP4_TR3
    %%%% correspondigly to Xtrain_woofers  
    
        % define training set and test set
        %%%%%%%%%%%%%%%%%% qua se non srotolo ci 
        %%%%%%%%%%%%%%%%%% va la y
    N               = size(Y_3WAY_WOOF(:,attr,:), 3);			% splitto sui dati di cui so l'outcome
    n_train         = floor(N*perc_train); 
    
    %
    %
    %
    % RANDOMLY take from X_sel and put them into the training set, remaining ones in test set
    rperm           = randperm(N); %choose elements in a random way
    train_indexes   = rperm(1:n_train);
    test_indexes    = rperm(n_train+1:end);
%     % NOT RANDOMLY 
%     non_perm = 1:N;
%     train_indexes   = non_perm(1:n_train);
%     test_indexes    = non_perm(n_train+1:end);
    
    % X,Y too should be divided into training and test set 
    X_train         = Xtrain_woofers;
    Y_3WAY_WOOF_TRAIN = Y_3WAY_WOOF(:,attr,train_indexes);
    X_test          = Xtrain_woofers;
    Y_3WAY_WOOF_TEST = Y_3WAY_WOOF(:,attr,test_indexes);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FEATURE SELECTION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (FROM TRAINING DATASET AVERAGED)
    %
    %
    %
    %%%%%%%%%%%%%% TRY RIDGE REGRESSION
    % to find the coefficients of a ridge regression model
    %     k = N_selected;
    %     b = ridge(Y_train,X_train,k,1);
    %
    %%%%%%%%%%%%%% ALL AUTOMATIC WITH STEPWISE (so whole training matri
    %
    stepwise_model = stepwiselm(X_train, correlation_weighting(Y_3WAY_WOOF_TRAIN),'Criterion','AIC');
    stepwise_prediction             = predict(stepwise_model, X_test);
    %[b_fit,se,pval,inmodel,stats,nextstep,history] = stepwisefit(X_train, Y_train);
    %
    %%%% https://www.mathworks.com/help/stats/stepwisefit.html


    %
    %
    %     R ranking, W weight. The lower R, the higher W (W is a metrics of
    %     importance for the feature). R organizes features in order of
    %     importance. Low ranked features are the most important. We select only
    %     features with a low rank value
    %
    % https://stats.stackexchange.com/questions/138458/proper-variable-selection-use-only-training-data-or-full-data
    % ONLY TRAINING MATRIX
    Y_featureselection = correlation_weighting(Y_3WAY_WOOF_TRAIN);
    %
    %%%%%%%%%%%%%% DECIDE HOW MANY FEATURES TO RETAIN
    % N_selected predictors requires a size(Y_train) greater than 50 + 8 * N_selected for tests of the 
    % overall model and a sample size greater than 104 + N_selected for testing whether a specific predictor 
    % has an influence
    %
    %
    N_selected          = 5;           %number of LLFs to retain after feature selection
    [R, W]               = relieff(Xtrain_woofers,  Y_featureselection,20);
    selected_features   = find(R <= N_selected);    % indeces of most significant features
    % RETAIN COLUMNS CORRESPONDING TO FEATURES
    X_sel_train              = X_train(:, selected_features);
    X_sel_test               = X_test(:, selected_features);
    
    %%%%%%%%%%%%%% CHECK STANDARD DEVIATION OF FEATURES
    %     std_features = std(Xtrain_woofers,0,1);
    %     [~,ind_min]= min(std_features);
    %
    

    % %
    % %
    % % DIVIDE TRAIN AND TEST CORRESPONDIGLY TO SPEAKER TRACK 
    % % (OR MAKE IT RANDOM IN THE SAME WAY )
    X_train         = X_sel_train;
    Y_train         = correlation_weighting(Y_3WAY_WOOF_TRAIN);
    X_test          = X_sel_test;
    Y_test          = correlation_weighting(Y_3WAY_WOOF_TEST);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TEST DIFFERENT MODELS!!

    linear_model    = fitlm(X_train, Y_train,'poly33333');
    svr_model       = fitrsvm(X_train, Y_train,'KernelFunction','polynomial'); % try different parameters!
    % % 
    % % Try also SVM lib here
    
    
    %
    %
    %%%%%%%%
    %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TEST STUFF

    linear_prediction               = predict(linear_model, X_test);
    svr_prediction                  = predict(svr_model, X_test);

         
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE PREDICTION ERRORS (for
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% each algorithm)
    % https://www.mathworks.com/help/stats/linearmodel.predict.html
    %
    % See links for confidence bounds ecc... Già viene dato nella funzione
    % di matlab
    %
    %
    k = N_selected;
    [RMSE_linear(attr), R2_linear(attr),adjR2_linear(attr)]  = error_metrics(linear_prediction, Y_test,k);
    [RMSE_svr(attr), R2_svr(attr),adjR2_svr(attr)]        = error_metrics(svr_prediction, Y_test,k);
    [RMSE_stepwise_model(attr), R2_stepwise_model(attr),adjR2_stepwise_model(attr)]        = error_metrics(stepwise_prediction, Y_test,k);
    %[RMSE_nonlinear(attr), R2_nonlinear(attr)]        = error_metrics(nonlinear_prediction, Y_test);
    
    
    %%%%%%%%%%%%% RAPID CHECK PLSREGRESSION
     [XL,yl,XS,YS,beta,PCTVAR] = plsregress(X_train,Y_train,2);
figure
plot(1:2,cumsum(100*PCTVAR(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in y');
    
end

%%%%%%%%%%%%%%%%%% PLOTTING

figure
x_labels = {'Attribute 1', 'Attribute 2', 'Attribute 3'};
bar([RMSE_linear' RMSE_svr' RMSE_stepwise_model'] );
title('RMSE for all Attributes');
legend('linear', 'svr','stepwise linear');
xticklabels(x_labels);

figure
bar([R2_linear' R2_svr' R2_stepwise_model'] );
title('R2 for all Attributes');
legend('linear', 'svr','stepwise linear');
xticklabels(x_labels);

figure
x_labels = {'Attribute 1', 'Attribute 2', 'Attribute 3'};
bar([adjR2_linear' adjR2_svr' adjR2_stepwise_model'] );
title('adjR2 for all Attributes');
legend('linear', 'svr','stepwise linear');
xticklabels(x_labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%% GRAPHIC CHECK IF MAX TWO FEATURES
%
%
% https://www.mathworks.com/help/curvefit/getting-started-with-curve-fitting-toolbox.html
% https://www.mathworks.com/help/curvefit/linear-and-nonlinear-regression.html
if N_selected <=2
    switch N_selected
        case 1
            ics = X_train(:,1);
            cftool
        case 2
            ics = X_train(:,1)
            ipsilon = X_train(:,2);
            cftool
    end
end


     