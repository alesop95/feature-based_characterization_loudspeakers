%function sd = spec_decrease(spec, Fs)
%Computes the spectral decrease of the signal whose spectrum is spec at the
%sampling frequency Fs.
%Author: Davide Riva, modified by Fabio Antonacci and Massimiliano Zanoni
%Created on 4/04/2007 and modified on 15/05/2009 and 09/05/2012

function sd = spec_decrease(spec)
 
    T1 = (1./sum(abs(spec(2:end,:))));
    S1 = repmat(abs(spec(1,:)),size(spec,1)-1,1);
    D = linspace(1,size(spec,1)-1,size(spec,1)-1)';
    sd = T1.*sum((abs(spec(2:end,:)) - S1)./D);
    
end
