rez = zeros(12, 4);
P = zeros(12, 5);
all = tablica{3}(2:end, 2:9);   %signal 102 prvi se upisuje u all
                                %ispred petlje kako bi se moglo provesti
                                %spajanje matrica
%unos podataka za ucenje
for q = 4 : 48 %krece od 4. signala zato sto je 3. vec upisan, a 1. i 2. ni ne trebaju biti
   if q == 1 || q == 2 || q == 4 || q == 7 || q == 17 || q == 19 ||  ...
          q == 21  || q == 29 || q == 35 || q == 41 || q == 42 || q == 45
   else
       all = [all; tablica{q}(2:end, 2:9)]; %spajanje dosadasnjih podataka s novim
   end
end

T = array2table(all); %pretvorba matrice u tablicu
T.Properties.VariableNames = {'U', 'AUC', 'AUCd', 'RR', ...
    'RRp', 'RRd', 'Ud', 'vrsta'}; %zapis naziva varijabli
L = fitcknn(T, 'vrsta');    %stvaranje modela klasifikatora prema danoj tablici
                            %vraca se vrijednost varijable vrsta

rbr = 1;
for q = 1 : 48
    TP = 0;
    FN = 0;
    FP = 0;
    
    %klasifikacija otkucaja za 12 testnih signala
    if q == 1 || q == 2 || q == 4 || q == 7 || q == 17 || q == 19 ||  ...
          q == 21  || q == 29 || q == 35 || q == 41 || q == 42 || q == 45
        [m, n] = size(tablica{q});
        
        vrsta = predict(L, tablica{q}(:, 2 : 8)); %klasifikacija
        
        %zapis rezultata dobivenih klasifikacijom
        rez(rbr, 2) = sum(char(vrsta) == 'V'); %klasificirano kao PVC
        rez(rbr, 1) = sum(char(vrsta) == 'N'); %klasificirano kao N
        
        %zapis ocekivanih rezultata prema anotacijama
        rez(rbr, 4) = sum(char(tablica{q}(:, 9)) == 'V'); %u anotacijama PVC
        rez(rbr, 3) = sum(char(tablica{q}(:, 9)) == 'N'); %u anotacijama N
        
        %usporedba rezultata dobivenih klasifikacijom s anotacijama
        anot = tablica{q}(:, 9);
        TP = length(find(vrsta == 'V' & anot == 'V' | vrsta == 'N' & anot == 'N'));
        FP = length(find(vrsta == 'V' & anot == 'N'));
        FN = length(find(vrsta == 'N' & anot == 'V'));
        
        %zapis na isti na?in kao kod detekcije QRS kompleksa
        P(rbr, 1) = TP;
        P(rbr, 2) = FN;
        P(rbr, 3) = FP;
        
        P(rbr, 4) = TP / (TP + FN) * 100;
        P(rbr, 5) = TP / (TP + FP) * 100;
        rbr = rbr + 1;
    end
end
ukupnoTP = sum(P(:, 1));
ukupnoFN = sum(P(:, 2));
ukupnoFP = sum(P(:, 3));
sensitivity = ukupnoTP / (ukupnoTP + ukupnoFN) * 100
predictivity = ukupnoTP / (ukupnoTP + ukupnoFP) * 100

%klasifikacija s treniranjem na balansiranom skupu
rez_2 = zeros(12, 4);
P_2 = zeros(12, 5);
all_2 = tablica_pvc(:, 2:9);
all_2 = [all_2; tablica_normal(:, 2:9)];
T_2 = array2table(all_2); %pretvorba matrice u tablicu
T_2.Properties.VariableNames = {'U', 'AUC', 'AUCd', 'RR', ...
    'RRp', 'RRd', 'Ud', 'vrsta'}; %zapis naziva varijabli
L_2 = fitcknn(T_2, 'vrsta');    %stvaranje modela klasifikatora prema danoj tablici
                                %vraca se vrijednost varijable vrsta

rbr = 1;
for q = 1 : 48
    TP = 0;
    FN = 0;
    FP = 0;
    
    %klasifikacija otkucaja za 12 testnih signala
    if q == 1 || q == 2 || q == 4 || q == 7 || q == 17 || q == 19 ||  ...
          q == 21  || q == 29 || q == 35 || q == 41 || q == 42 || q == 45
        [m, n] = size(tablica{q});
        vrsta = predict(L_2, tablica{q}(:, 2 : 8)); %klasifikacija
        
        %zapis rezultata dobivenih klasifikacijom
        rez_2(rbr, 2) = sum(char(vrsta) == 'V'); %klasificirano kao PVC
        rez_2(rbr, 1) = sum(char(vrsta) == 'N'); %klasificirano kao N

        %zapis ocekivanih rezultata prema anotacijama
        rez_2(rbr, 4) = sum(char(tablica{q}(:, 9)) == 'V'); %u anotacijama PVC
        rez_2(rbr, 3) = sum(char(tablica{q}(:, 9)) == 'N'); %u anotacijama N
        
        %usporedba rezultata dobivenih klasifikacijom s anotacijama
        anot = tablica{q}(:, 9);
        TP = length(find(vrsta == 'V' & anot == 'V' | vrsta == 'N' & anot == 'N'));
        FP = length(find(vrsta == 'V' & anot == 'N'));
        FN = length(find(vrsta == 'N' & anot == 'V'));
        
        %zapis na isti na?in kao kod detekcije QRS kompleksa
        P_2(rbr, 1) = TP;
        P_2(rbr, 2) = FN;
        P_2(rbr, 3) = FP;
        
        P_2(rbr, 4) = TP / (TP + FN) * 100;
        P_2(rbr, 5) = TP / (TP + FP) * 100;
        rbr = rbr + 1;
    end
end
ukupnoTP = sum(P_2(:, 1));
ukupnoFN = sum(P_2(:, 2));
ukupnoFP = sum(P_2(:, 3));
sensitivity_2 = ukupnoTP / (ukupnoTP + ukupnoFN) * 100
predictivity_2 = ukupnoTP / (ukupnoTP + ukupnoFP) * 100


