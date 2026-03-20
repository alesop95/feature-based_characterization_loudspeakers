function [] = reference_mask()

%% Generation of N_listeners * (N_attributes*N_tracks*N_speakers) Balanced Latin Square rectangle
% Alessio Sopranzi 16/01/2020

clear all
clc
close all

N_attr = 3;
N_tracks = 3;
N_speakers = 4;
N_listeners = 15;

max_period_of_repetition_third_symbol = N_attr
row_length = N_attr*N_tracks*N_speakers;
column_length = N_attr*N_tracks*N_speakers;

% Initialization
A_complete = zeros(row_length,column_length)
first_symbol = zeros(1,column_length)
second_symbol = zeros(1,column_length)
third_symbol = zeros(1,column_length)

%% Repetition of third symbol
% Create here mod_vector repeated up to column_length
for ii = 1:max_period_of_repetition_third_symbol
    base_mod(ii) = max_period_of_repetition_third_symbol+ii+1
end

uno = ones(1,column_length/length(base_mod));
due = base_mod;
K = kron(uno,due);  

mod_vector = mod(K, max_period_of_repetition_third_symbol+1);
third_symbol = mod_vector;


%% Repetition of second symbol
% Second symbol repeats itself "max_period_of_repetition_third_symbol"
% times and then changes

base_second_symbol = linspace(1,N_tracks,N_tracks)
second_symbol = repelem(base_second_symbol,N_attr)
second_symbol = repmat(second_symbol,1,N_speakers)

% To convert in letter (...)

%% Repetition of first symbol
% First symbol is 1111....111222......222333....333444....444 
% 111....111 is N_attr * N_tracks times

base_first_symbol = linspace(1,N_speakers,N_speakers)
first_symbol = repelem(base_first_symbol,N_attr*N_tracks)

%% Population of Matrix of string 

A_complete=string(A_complete)

% Fill the first row
for ii = 1:column_length  

    A_complete(1,ii)= sprintf('%d%d%d', first_symbol(ii), second_symbol(ii), third_symbol(ii))
 
end 

% Fill rows beneath according to Balanced Latin Square
tail = strings(1)
for jj=2:N_attr*N_tracks*N_speakers
    % Retain last element from previous row
    tail = A_complete(1,(1:(jj-1)))
        % Append    
    A_complete(jj,:)= [A_complete(1,jj:end) tail]
    
end

%C = cellstr( A )
%save('lookuptable_cellarray','C')
save('lookuptable_string_120','A_complete')

%%
A_sampled = zeros(N_listeners, N_attr*N_tracks*N_speakers)
for sampl=1:1:N_listeners
    
    if sampl <= 6
A_sampled(sampl,:) = A_complete((round((N_attr*N_tracks*N_speakers/N_listeners))*(sampl-1))+1,:)
    elseif sampl >= 7
   A_sampled(sampl,:) = A_complete((round((N_attr*N_tracks*N_speakers/N_listeners))*(sampl-1))+4,:)
    end
end

% save('reference_mask','A_sampled')
assignin('base','reference_mask',A_sampled(1,:));


end

