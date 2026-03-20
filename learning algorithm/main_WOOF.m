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


%% LOAD AND PREPROCESSING OBJECTIVE DATA 
%
%%%%%% Load extracted features
%
% PUT DATA FROM FEATURE EXTRACTION ON FOLDER "X"
load('./X/X_woofer_training.mat');

%
%%%%%% LOAD MEASURED FEATURES
%
% (to follow same order in the listening room from sx to dx
% 1,2,3,4 read column 1,2,3,4 respectively in .csv file 
WOOF_measured_features = readmatrix('./X/woofer_data.csv');

%
%%%%%% Compose whole training matrix
% (each row is a speaker data)

Xtrain_woofers = [WOOF_measured_features',X_w];

clearvars -except Xtrain_woofers N_ATTR N_SPEAK N_TRACKS N_SUBJECTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ADD TRACK AS REPLICATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ON X
%
% % Create replicate with appended at the end the number of track (as a
% % further feature)
Xtrain_woofers = [repmat(Xtrain_woofers(1,:),N_TRACKS,1);repmat(Xtrain_woofers(2,:),3,1);...
    repmat(Xtrain_woofers(3,:),N_TRACKS,1);repmat(Xtrain_woofers(4,:),N_TRACKS,1)];
append = [1;2;3;1;2;3;1;2;3;1;2;3];

Xtrain_woofers = [Xtrain_woofers,append];

clear append



%%  LOADING AND PREPROCESSING SUBJECTIVE DATA
%
%%%%%%%%%%%%%%%%%%%%%%% Load [attr_1 | attr_2 | attr_3]
% where attr_i are all the reatings (N_ATTR*N_SPEAK = 12 ) for that
% attribute where each column is
% SP1_TR1,SP1_TR2,SP1_TR3,SP2_TR1,SP2_TR2,SP2_TR3,SP3_TR1,SP3_TR2,SP3_TR3,SP4_TR1,SP4_TR2,SP4_TR3
%

WOOF_ratings_attr1 = readmatrix('./Y/woofer__attr1.csv');
WOOF_ratings_attr2 = readmatrix('./Y/woofer__attr2.csv');
WOOF_ratings_attr3 = readmatrix('./Y/woofer__attr3.csv');

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

%%
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
% %
% % % % %%
% %training and testing a different model and feature set for each ATTRIBUTE
% % % % 
% % % %
% %% SOLUZIONE (I)
% %
% %

    X1 = Xtrain_woofers;
    X2 = Xtrain_woofers;
    X3 = Xtrain_woofers;


for attr = 1:N_ATTR 
    

 
    %%%%% |r|<0.66 retain
    switch attr
        case 1
            X1 = X1(:,[20,22,26,31,34,35,38,39,42,43,49,50,51,53,57,58,59]);
        case 2
            X2 = X2(:,[11,20,22,29,33,34,36,43,48,50,52,54,59]);
        case 3
            X3 = X3(:,[1,2,4,5,6,7,8,11,15,18,19,21,23,25,28,35,37,39,40,41,42,44,46,47,53,55,56,58]);
    end
    
    
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

    
    % X,Y too should be divided into training and test set 
  %  X_train         = Xtrain_woofers;
    Y_3WAY_WOOF_TRAIN = Y_3WAY_WOOF(:,attr,train_indexes);
  %  X_test          = Xtrain_woofers;
    Y_3WAY_WOOF_TEST = Y_3WAY_WOOF(:,attr,test_indexes);
    
    switch attr
        case 1
            X_train = X1;
            X_test = X1;
        case 2
            X_train = X2;
            X_test = X2;
        case 3
            X_train = X3;
            X_test= X3;
    end
    
    
    
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
    %%%%%%%%%%%%%% ALL AUTOMATIC WITH STEPWISE (so whole training matrix)
    %
    stepwise_model = stepwiselm(X_train, correlation_weighting(Y_3WAY_WOOF_TRAIN),'Criterion','AIC');
    stepwise_prediction             = predict(stepwise_model, X_test);
    %[b_fit,se,pval,inmodel,stats,nextstep,history] = stepwisefit(X_train, Y_train);
    %
    %%%% https://www.mathworks.com/help/stats/stepwisefit.html

    %
    %  
    %
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
    [R, W]               = relieff(X_train,  Y_featureselection,20);
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

    linear_model    = fitlm(X_train, Y_train);
  
    svr_model       = fitrsvm(X_train, Y_train,'KernelFunction','polynomial'); % try different parameters!
 
    %%% https://towardsdatascience.com/an-introduction-to-support-vector-regression-svr-a3ebc1672c2
    
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
            ics = X_train(:,1);
            ipsilon = X_train(:,2);
            cftool
    end
end
    
aaa = 0;  
    
    


    
end

%%%%%%%%%%%%%%%%%% PLOTTING

figure
x_labels = {'Loudness', 'Timbral Balance', 'Preference'};
bar([RMSE_linear' RMSE_svr' RMSE_stepwise_model'] );
title('RMSE for all Attributes');
legend('Linear', 'SVR','Stepwise linear');
xticklabels(x_labels);

figure
x_labels = {'Loudness', 'Timbral Balance', 'Preference'};
bar([R2_linear' R2_svr' R2_stepwise_model'] );
title('R2 for all Attributes');
legend('Linear', 'SVR','Stepwise linear');
xticklabels(x_labels);

figure
x_labels = {'Loudness', 'Timbral Balance', 'Preference'};
bar([adjR2_linear' adjR2_svr' adjR2_stepwise_model'] );
title('Adj R2 for all Attributes');
legend('Linear', 'SVR','Stepwise linear');
xticklabels(x_labels);


     