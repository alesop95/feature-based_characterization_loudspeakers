clear all
clc
close all

N_ATTR = 3;
N_SPEAK = 4;

%% FEATURE TRAINING MATRIX

%%%%%%%%%%%%%%%%%%%%%%% LOAD DATA 
%
%%%%%% Load extracted features
%
load('./X/X_tweeter_training.mat');

%
%%%%%% Load measured features
%
%
% (to follow same order in the listening room from sx to dx
% 1,2,3,4 read column 1,2,3,4 respectively in .csv file 
TWEET_measured_features = readmatrix('./X/tweeter_data.csv');

%
%%%%%% Compose whole training matrix
% (each row is a speaker data)
Xtrain_tweeters = [TWEET_measured_features',X_t];

clearvars -except Xtrain_tweeters

% %  
% % 
% % Normalize the LLFs (between 0 and 1) 
% Xtrain_woofers = (Xtrain_woofers - min(Xtrain_woofers))./(max(Xtrain_woofers) - min(Xtrain_woofers));
% Xtrain_tweeters = (Xtrain_tweeters - min(Xtrain_tweeters))./(max(Xtrain_tweeters) - min(Xtrain_tweeters));

%%  SUBJECTIVE ANNOTATIONS
%
%%%%%%%%%%%%%%%%%%%%%%% Load [attr_1 | attr_2 | attr_3]
% where attr_i are all the reatings (N_ATTR*N_SPEAK = 12 ) for that
% attribute where each column is
% SP1_TR1,SP1_TR2,SP1_TR3,SP2_TR1,SP2_TR2,SP2_TR3,SP3_TR1,SP3_TR2,SP3_TR3,SP4_TR1,SP4_TR2,SP4_TR3
%

TWEET_ratings_attr1 = readmatrix('./Y/tweeter__attr1.csv');
TWEET_ratings_attr2 = readmatrix('./Y/tweeter__attr2.csv');
TWEET_ratings_attr3 = readmatrix('./Y/tweeter__attr3.csv');

%%%% 3WAY structure with each slice |/ is for a particular attribute || |row =
%%%% speaker/track ratings and /// column = listeners
% Y_3WAY_TWEET = cat(3,TWEET_ratings_attr1',TWEET_ratings_attr2',TWEET_ratings_attr3');
%%% dimensions not consistent here!!!

% Ytrain_woofers = 
% Ytrain_tweeters = 



%
%%%%%%%%%%%%%%%%%%%%%%%
%

%
%%%%%%%%%%%%%%%%%%%%%%%
%
