%zove za svaki signal fciju transformacije
mat = dir('*.mat');
for i = 1:length(mat) 
    load(mat(i).name);
    if (i == 14) 
        signal = val(2,1:end); 
    else 
        signal = val(1,1:end); 
    end
    [M, fi] = phasorTransform(signal);
end