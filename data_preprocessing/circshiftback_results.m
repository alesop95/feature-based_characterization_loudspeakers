%%% ONLY FOR SAFETY
if exist('results_complete_ordered_woofer','var') && exist('results_complete_ordered_tweeter','var')

clc
close all 
clearvars -except results_complete_ordered_tweeter results_complete_ordered_woofer tot_subj tot_combinations


%%%%%%%%%%%%%%%%%%%%%%          ACCORDING TO THE LISTENER FILL SHIFT
%%%%%%%%%%%%%%%%%%%%%%          VECTOR MASK
shift = zeros(1,tot_subj);  

%%% SAME LOGIC THERE WAS ON THE CONSTRUCTION!
for ii=1:tot_subj
    if ii <= 6
        shift(ii) = 2*(ii-1);
            elseif ii >= 7
           shift(ii) = 2*(ii-1)+3;
    end
end

%%%%%%%%%%%%%%%%%%%%%%          ROTATE BACK RESULTS
for jj=1:tot_subj
        results_complete_ordered_woofer(jj,:)=circshift(results_complete_ordered_woofer(jj,:), -shift(jj));
        results_complete_ordered_tweeter(jj,:)=circshift(results_complete_ordered_tweeter(jj,:), -shift(jj));
end  

%%%%%%%%%%%%%%%%%%%%%%          SAVE RESULTS FOR SAFETY
results_woofer = results_complete_ordered_woofer;
results_tweeter = results_complete_ordered_tweeter;

reference_mask()
clear ii jj results_complete_ordered_woofer results_complete_ordered_tweeter

end

