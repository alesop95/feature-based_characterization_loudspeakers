%% Generate results for RATA listening tests

clear
close all
clc

%% Dimensions
N_list = 10; % number of listeners
N_attr = 15; % number of attributes
N_track = 5; % number of tracks
N_syst = 4; % number of systems

% To choose which of the 4 plot against MSE
N_list_array = linspace(1,10,10);
N_attr_array = linspace(1,30,30);
N_track_array = linspace(1,5,5);
N_syst_array = linspace(1,5,5);


%% Choose parameter <--
% Parameter to plot MSE w.r.t.
chosen_parameter = 4;


if chosen_parameter == 1
    par = 'Listeners';               
    array = N_list_array;           % cycle on listeners themselves
    N_attr = 15; % number of attributes
    N_track = 5; % number of tracks
    N_syst = 4; % number of systems
    
elseif chosen_parameter == 2
    par = 'Attributes';
    N_list = 10; % number of listeners
    array = N_attr_array;           % cycle on attributes
    N_track = 5; % number of tracks
    N_syst = 4; % number of systems
   
elseif chosen_parameter == 3
    par = 'Tracks';
    N_list = 10; % number of listeners
    N_attr = 15; % number of attributes
    array = N_track_array;           % cycle on tracks
    N_syst = 4; % number of systems
    
elseif chosen_parameter == 4
    par = 'Loudspeakers';
    N_list = 10; % number of listeners
    N_attr = 15; % number of attributes
    N_track = 5; % number of tracks
    array = N_syst_array;           % cycle on systems
    
end

NRMSE = zeros(1,length(array));


for i = 1:length(array)
    N_parameter = array(i); 


%% Generate fake correlations between variables
%  Distributions of listener ratings are assumed to be Gaussian
%  Ratings are normalized between 0 and 1
%rng('v5normal');

seed = 500*rand()+ 1000-700*rand();
sprev = rng(seed,'v5uniform')

    switch chosen_parameter
     case 1
        M = 0.53+0.3*(2*rand([N_attr, N_syst])-1); % matrix containing the means
        STD = 0.15*(rand([N_attr, N_syst])); % matrix containing the standard deviations

        %  Different attribue elicitation due to different tracks are modeled as
        %  scaling of the mean
        W = 0.8+0.2*rand([N_attr, N_track]); % matrix containing the track scaling
        
     case 2
        M = 0.53+0.3*(2*rand([N_parameter, N_syst])-1); % matrix containing the means
        STD = 0.15*(rand([N_parameter, N_syst])); % matrix containing the standard deviations
        
        %  Different attribue elicitation due to different tracks are modeled as
        %  scaling of the mean
        W = 0.8+0.2*rand([N_parameter, N_track]); % matrix containing the track scaling
        
     case 3 
        M = 0.53+0.3*(2*rand([N_attr, N_syst])-1); % matrix containing the means
        STD = 0.15*(rand([N_attr, N_syst])); % matrix containing the standard deviations

        %  Different attribue elicitation due to different tracks are modeled as
        %  scaling of the mean
        W = 0.8+0.2*rand([N_attr, N_parameter]); % matrix containing the track scaling
        
     case 4 
        M = 0.53+0.3*(2*rand([N_attr, N_parameter])-1); % matrix containing the means
        STD = 0.15*(rand([N_attr, N_parameter])); % matrix containing the standard deviations

        %  Different attribue elicitation due to different tracks are modeled as
        %  scaling of the mean
        W = 0.8+0.2*rand([N_attr, N_track]); % matrix containing the track scaling
    end 
        

%% Generate fake test results
%  One test = One combination of (attribute, track, system)
%  RES matrix contains the test results
    switch chosen_parameter
    case 1
        RES = zeros(N_parameter, N_attr, N_track, N_syst);
        for ii = 1:N_syst
            for jj = 1:N_track
                for kk = 1:N_attr
                    RES(:,kk,jj,ii) = M(kk,ii)*W(kk,jj) + STD(kk,ii)*randn([N_parameter,1]);
                end
            end
        end
    case 2
        RES = zeros(N_list, N_parameter, N_track, N_syst);
         for ii = 1:N_syst
            for jj = 1:N_track
                for kk = 1:N_parameter
                    RES(:,kk,jj,ii) = M(kk,ii)*W(kk,jj) + STD(kk,ii)*randn([N_list,1]);
                end
            end
        end
    case 3
        RES = zeros(N_list, N_attr, N_parameter, N_syst);
        for ii = 1:N_syst
            for jj = 1:N_parameter
                for kk = 1:N_attr
                    RES(:,kk,jj,ii) = M(kk,ii)*W(kk,jj) + STD(kk,ii)*randn([N_list,1]);
                end
            end
        end
    case 4
        RES = zeros(N_list, N_attr, N_track, N_parameter);
        for ii = 1:N_parameter
            for jj = 1:N_track
             for kk = 1:N_attr
                RES(:,kk,jj,ii) = M(kk,ii)*W(kk,jj) + STD(kk,ii)*randn([N_list,1]);
             end
            end
        end
    end

%  Avoid values above 1 and below 0
RES(RES(:)<0) = 0;
RES(RES(:)>1) = 1;


    
        %% Split into training and testing (on # of listeners)
    % percentage of 
    % training points = 70%, validation = 30%, test = 0% 
    p = 0.7;

    % (SYNTAX) [trainInd,valInd,testInd] = dividerand(Q,trainRatio,valRatio,testRatio)
    % N_list, N_attr, N_track, N_syst
    % ALWAYS SPLIT TRAINING AND VALIDATION DATA W.R.T LISTENER DIMENSION
    if chosen_parameter == 1
        % if N_parameter > 2
        [trainInd1,valInd1,testInd1] = divideblock(N_parameter,p,1-p,0);
    else
        [trainInd1,valInd1,testInd1] = divideblock(N_list,p,1-p,0);
    end 
    
    train_RES = RES(trainInd1,:,:,:);
    val_RES = RES(valInd1,:,:,:);

    % Check dimensions
    size(train_RES)
    size(val_RES)
    
    
    % According to the parameter
    %% Training and validation + MSE calculation
    % Train the network and evaluate performance.
    
    % RESHAPE MATRIX INTO 2X2 (N_list * N_attr, N_track * N_syst)
    % need to transpose rows and columns before and after the reshape since matlab operates column-wise.
    % an specify a single dimension size of [] to have the dimension size automatically calculated
    switch chosen_parameter
    case 1
        train_RES_shaped = reshape(train_RES,  N_parameter*N_attr,  [])';
        val_RES_shaped = reshape(val_RES,  N_parameter*N_attr,  [])'
        
    case 2
        train_RES_shaped = reshape(train_RES,  N_list*N_parameter,  [])';
        val_RES_shaped = reshape(val_RES,  N_list*N_parameter,  [])'
        
    case 3
        train_RES_shaped = reshape(train_RES,  [],  N_parameter*N_syst)';
        val_RES_shaped = reshape(val_RES,  [],  N_parameter*N_syst)';
        
    case 4
        train_RES_shaped = reshape(train_RES, [],  N_track*N_parameter)';
        val_RES_shaped = reshape(val_RES,  [],  N_track*N_parameter)';
        
    end

    
    % Check dimensions
    size(train_RES_shaped')
    size(val_RES_shaped')    


    % first return a network object and then train
    %net = feedforwardnet(5);
    %net.performParam.normalization = 'percent';
    %net = train(net, train_RES_shaped',val_RES_shaped');
    %y = net(train_RES_shaped');
    
    X = train_RES_shaped;
    Y = val_RES_shaped;
    [~,~,E,~,~] = mvregress(X,Y,'algorithm','cwls');
    
    
    % Compute normalized rms
    %NRMSE(i) = (1/norm(train_RES_shaped',2))*(norm((val_RES_shaped' - y),2));
    
    NRMSE(i) = (1/norm(train_RES_shaped',2))*(norm((E),2));
    
end


%% Plot of MSE against variation of (each) chosen parameter

figure()
plot(array,NRMSE)
xlabel('# of selected parameter')
ylabel('Norm of matrix error')
title('Norm of error Matrix for different values of selected parameter')
grid on;
