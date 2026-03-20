%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USE OF NATSORTFILES
% Cite As
% Stephen Cobeldick (2020). Natural-Order Filename Sort 
% (https://www.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort), 
% MATLAB Central File Exchange. Retrieved February 4, 2020.

clc 
close all

if exist('results_complete_ordered_woofer','var')
   clearvars -except results_complete_ordered_woofer
else
    clear all 
end

%%%%%%%%%%%%%%%%%%%%%%%%%% # OF SUBJECT AND COMBINATIONS OF TRACK, ATTR,
%%%%%%%%%%%%%%%%%%%%%%%%%% SPEAKERS OF THE TEST
tot_subj = 15 ;
tot_combinations = 36;

%%%%%%%%%%%%%%%%%%%%%%%%%% READ ALL .mat FILE AND SORT NAMES
a = string(zeros(tot_subj,1));

oldFolder = pwd;        % save current path
cd 'risultati copia\tweeter'

files = dir('*.mat');
for k = 1:numel(files)
    a(k) = files(k).name;
end
a = cellstr(a');
for k = 1:numel(files)
    names = natsortfiles(a);
end
names = names';
names = string(names);

%%%%%%%%%%%%%%%%%%%%%%%%%% FILL THE FINAL ORDERED MATRIX
results_complete_ordered_tweeter = zeros(tot_subj, tot_combinations);
for k = 1:numel(files)
    load(names(k));
    
    % Convert to doubles the values!
    results_complete_ordered_tweeter(k,:) = str2double(results);
end

cd(oldFolder)                 % restore main path
cd