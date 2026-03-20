function centr = spec_centroid(spec,freq)
    centr = freq' * abs(spec) / sum(abs(spec));
end
    
