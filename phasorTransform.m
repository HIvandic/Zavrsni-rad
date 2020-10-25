function [M,fi] = phasorTransform(x)
%x je signal
% y(n) = R + j*x(n)
%fcija racuna vrijednosti velicine(magnitude) i phase
R = 0.001; %konstantna vrijednost
for i = 1:length(x)
    M(i) = sqrt(power(R,2)+power(x(i),2));
    fi(i) = atan(x(i)/R);
end
end

