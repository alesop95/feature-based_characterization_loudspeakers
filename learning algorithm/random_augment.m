function [X,Y] = random_augment(Xtrain_woofers,Ytrain_woofers)
% %
% %
first_row_expanded_X = zeros(1,size(Xtrain_woofers,2));
second_row_expanded_X = zeros(1,size(Xtrain_woofers,2));
third_row_expanded_X = zeros(1,size(Xtrain_woofers,2));
fourth_row_expanded_X = zeros(1,size(Xtrain_woofers,2));
% %
first_row_expanded_Y = zeros(1,size(Ytrain_woofers,2));
second_row_expanded_Y = zeros(1,size(Ytrain_woofers,2));
third_row_expanded_Y = zeros(1,size(Ytrain_woofers,2));
fourth_row_expanded_Y = zeros(1,size(Ytrain_woofers,2));
% %
% %
INTERVAL = 100;                      %%%%% The lesser, the more variability
N_augmented_rows = 600;
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Xtrain_woofers,2))/INTERVAL;
    first_row_expanded_X(ii,:) = Xtrain_woofers(1,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Xtrain_woofers,2))/INTERVAL;
    second_row_expanded_X(ii,:) = Xtrain_woofers(2,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Xtrain_woofers,2))/INTERVAL;
    third_row_expanded_X(ii,:) = Xtrain_woofers(3,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Xtrain_woofers,2))/INTERVAL;
    fourth_row_expanded_X(ii,:) = Xtrain_woofers(4,:) + a;
end
Xtrain_woofers = [Xtrain_woofers(1,:); first_row_expanded_X; Xtrain_woofers(2,:); second_row_expanded_X; ...
    Xtrain_woofers(3,:); third_row_expanded_X; Xtrain_woofers(4,:); fourth_row_expanded_X];

for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Ytrain_woofers,2))/INTERVAL;
    first_row_expanded_Y(ii,:) = Ytrain_woofers(1,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Ytrain_woofers,2))/INTERVAL;
    second_row_expanded_Y(ii,:) = Ytrain_woofers(2,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Ytrain_woofers,2))/INTERVAL;
    third_row_expanded_Y(ii,:) = Ytrain_woofers(3,:) + a;
end
for ii=1:N_augmented_rows
    rng('shuffle');
    a = randn(1,size(Ytrain_woofers,2))/INTERVAL;
    fourth_row_expanded_Y(ii,:) = Ytrain_woofers(4,:) + a;
end

Ytrain_woofers = [Ytrain_woofers(1,:); first_row_expanded_Y; Ytrain_woofers(2,:); second_row_expanded_Y; ...
    Ytrain_woofers(3,:); third_row_expanded_Y; Ytrain_woofers(4,:); fourth_row_expanded_Y];


X = Xtrain_woofers;
Y = Ytrain_woofers;
end

