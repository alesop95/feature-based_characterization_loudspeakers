function [W] = STATIS_weighting(Y_3WAY_WOOF,N_ATTR,N_SPEAK)


%%%%%%%%%%% Centre attributes for each assessor
for ii=1:size(Y_3WAY_WOOF,3)
    Y_3WAY_WOOF(:,:,ii) = Y_3WAY_WOOF(:,:,ii)- mean(Y_3WAY_WOOF(:,:,ii));
end

%%%%%%%%%%% Calculate association matrix W_i=X_i X_i^' relative to each
%%%%%%%%%%% assessor
W_i = zeros(N_ATTR*N_SPEAK,N_ATTR*N_SPEAK,size(Y_3WAY_WOOF,3));
for ii=1:size(Y_3WAY_WOOF,3)
W_i(:,:,ii) = squeeze(Y_3WAY_WOOF(:,:,ii))* (squeeze(Y_3WAY_WOOF(:,:,ii)))';
end

for ii=1:size(Y_3WAY_WOOF,3)
    for jj=1:size(Y_3WAY_WOOF,3)
%%%%%%%%%%% Calculate RV between W_i and W_j
        RV(ii,jj) = corr2(W_i(:,:,ii),W_i(:,:,jj));
    end
end

%%%%%%%%%%% The STATIS compromise is a weighted mean of the W_i in the
%%%%%%%%%%% following way W=?_i (a_i W_i) where 
%%%%%%%%%%% where (a_i )_(i=1,…,k) is the first eigenvector of the matrix of size 
%%%%%%%%%%% (k,k) containing the RV coefficients between assessors. 
[V,~] = eigs(RV);
%%% Retain firs eigenvector of the matrix
eigenfirst = V(:,1);

W = zeros(N_ATTR*N_SPEAK,N_ATTR*N_SPEAK);
for ii=1:size(Y_3WAY_WOOF,3)
    W = W + eigenfirst(ii)*W_i(:,:,ii);
end


end

