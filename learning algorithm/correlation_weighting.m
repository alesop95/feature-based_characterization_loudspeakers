function [Y_corr_weighted] = correlation_weighting(Y_3WAY_WOOF)

Y_mean_assessor = mean(Y_3WAY_WOOF,3);

for kk=1:size(Y_3WAY_WOOF,2)
for ii=1:size(Y_3WAY_WOOF,3)
w_ik(ii,kk) = corr(Y_mean_assessor(:,kk),Y_3WAY_WOOF(:,kk,ii));
end
end

w_ik = abs(w_ik);

for kk=1:size(Y_3WAY_WOOF,2)
for jj=1:size(Y_3WAY_WOOF,1)
Y_corr_weighted(jj,kk) = (  (squeeze(Y_3WAY_WOOF(jj,kk,:))') * w_ik(:,kk))/sum(w_ik(:,kk));
end
end


Y = Y_corr_weighted;
end

