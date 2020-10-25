TP = 0;
FN = 0;
FP = 0;
for i=1:48
    TP = TP + H(i,1);
    FN = FN + H(i,2);
    FP = FP + H(i,3);
end
S = TP / (TP + FN) * 100
PP = TP / (TP + FP) * 100