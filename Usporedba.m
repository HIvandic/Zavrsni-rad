tic
%usporedba broja otkrivenih R zubaca s brojem R zubaca iz anotacija 
mat = dir('*.mat');
[m,n]=size(anotacije);
%odreduje velicinu t.d. se ne mijenja u svakoj iteraciji
H = ones(48,5);
AUC = cell(1, 48);
AUCd = cell(1, 48);
RR = cell(1, 48);
RRp = cell(1, 48);
RRd = cell(1, 48);
U = cell(1, 48);
Ud = cell(1, 48);
tablica = cell(1, 48);

pvc = 1;
normal = 1;

for q = 1:length(mat)
    TruePositive = 0;
    FalsePositive = 0; 
    FalseNegative = 0;
    load(mat(q).name);
    if (q == 14) 
        signal = val(2,1:end); 
    else 
        signal = val(1,1:end); 
    end
    
    %uklanjanje suma
    signal = wdenoise(signal,2,'Wavelet','sym4', ...
            'DenoisingMethod','UniversalThreshold', ...
            'ThresholdRule','Soft','NoiseEstimate', ...
            'LevelDependent');
    signal = signal - mean(signal);
    
    %detekcija R zubaca
    [qrs_amp, qrs_i] = qrs_detection(signal);
    
    qrs_i_2 = zeros(length(qrs_i), 2);
    qrs_i_2(:, 1) = qrs_i(:, 1);
   
    [m, n] = size(anotacije{q});
    
    %racunanje TP, FN, FP;
    k = 1;
    for i=1:length(qrs_i)
        zastavica = 0;
        for j=1:m
            if (abs(qrs_i(i)-anotacije{q}(j)))<=27 %prihvaca unutar 54 uzorka
                TruePositive = TruePositive+1;
                zastavica = 1;
                %pridruzivanje anotacije s odgovaraju?im zupcem dobivenim detekcijom
                qrs_i_2(i, 2) =  anotacije{q}(j, 2); 
                break;
             end
        end
        if zastavica == 0
            FalseNegative = FalseNegative + 1;
        else
            k = k +1;
        end
    end
    for j=1:m
        zastavica = 0;
        for i=1:length(qrs_i)
            if (abs(qrs_i(i)-anotacije{q}(j)))<=27 
                zastavica = 1;
                break;
            end
        end
        if zastavica == 0
            FalsePositive = FalsePositive + 1;
        end
    end
    
    H(q,1) = TruePositive;
    H(q,2) = FalseNegative;
    H(q,3) = FalsePositive; 
    %racuna se osjetljivost
    H(q,4) = TruePositive / (TruePositive + FalseNegative) * 100;
    %racuna se pozitivna predvidivost
    H(q,5) = TruePositive / (TruePositive + FalsePositive) * 100;

    %feature extraction
    redni = 1;
    tablica{q} = zeros(TruePositive, 9);
    for k = 1 : length(qrs_i)
        
        element = qrs_i(k);
        oznaka = qrs_i_2(k, 2);
        
        %U = amplituda QRS kompleksa
        U{q}(k) = signal(element);
        
        %AUC = povrsina ispod signala od R(i)-50 ms do R(i)+50 ms
        %AUCd = razlika trenutni i prethodni AUC
        %RR = RR(i)
        %RRp = RR(i-1)
        %RRd = RR(i) - RR(i-1)
        %Ud = QRS(i) - QRS(i-1)
        
        ending = element + 0.05*360;
        if k ~= 1
            start = element - 0.05*360;
            if start < 1
                start = 1;
            elseif ending < 650000
                    x = start:1:ending;
                    AUC{q}(k) = trapz(signal(start:ending));
            else
                x = start:1:650000;
                AUC{q}(k) = trapz(signal(start:650000));
            end
            AUCd{q}(k) = AUC{q}(k) - AUC{q}(k-1);
            RR{q}(k) = qrs_i(k) - qrs_i(k-1);
            RRp{q}(k) = RR{q}(k-1);
            RRd{q}(k) = RR{q}(k) - RRp{q}(k);
            Ud{q}(k) = U{q}(k) - U{q}(k-1); 
        else
            x = 1:1:ending;
            AUC{q}(k) = trapz(signal(1:ending));
            AUCd{q}(k) = 0;
            RR{q}(k) = 0;
            RRp{q}(k) = 0;
            RRd{q}(k) = 0;
            Ud{q}(k)=0;
        end
        
        if char(oznaka) == 'V'
            tablica{q}(redni, 9) = 'V'; %PVC
            %PVC u zasebnu tablicu
            if q ~= 1 && q ~= 2 && q ~= 4 && q ~= 7 && q ~= 17 && q ~= 19 &&  ...
                q ~= 21 && q ~= 29 && q ~= 35 && q ~= 41 && q ~= 42 && q ~= 45
                tablica_pvc(pvc, 1) = qrs_i(k);
                tablica_pvc(pvc, 2) = U{1,q}(k);
                tablica_pvc(pvc, 3) = AUC{1,q}(k);
                tablica_pvc(pvc, 4) = AUCd{1,q}(k);
                tablica_pvc(pvc, 5) = RR{1,q}(k);
                tablica_pvc(pvc, 6) = RRp{1,q}(k);
                tablica_pvc(pvc, 7) = RRd{1,q}(k);
                tablica_pvc(pvc, 8) = Ud{1,q}(k);
                tablica_pvc(pvc, 9) = 'V';
                pvc = pvc + 1;
            end
        elseif char(oznaka) == 'N'
            tablica{q}(redni, 9) = 'N'; %N
            %N u zasebnu tablicu
            if q ~= 1 && q ~= 2 && q ~= 4 && q ~= 7 && q ~= 17 && q ~= 19 &&  ...
                q ~= 21 && q ~= 29 && q ~= 35 && q ~= 41 && q ~= 42 && q ~= 45
                tablica_n(normal, 1) = qrs_i(k);
                tablica_n(normal, 2) = U{1,q}(k);
                tablica_n(normal, 3) = AUC{1,q}(k);
                tablica_n(normal, 4) = AUCd{1,q}(k);
                tablica_n(normal, 5) = RR{1,q}(k);
                tablica_n(normal, 6) = RRp{1,q}(k);
                tablica_n(normal, 7) = RRd{1,q}(k);
                tablica_n(normal, 8) = Ud{1,q}(k);
                tablica_n(normal, 9) = 'N';
                normal = normal + 1;
            end
        else
            continue %ne upisuje u tablicu otkucaje koji nisu N ili V
        end
        tablica{q}(redni, 1) = qrs_i(k);
        tablica{q}(redni, 2) = U{1,q}(k);
        tablica{q}(redni, 3) = AUC{1,q}(k);
        tablica{q}(redni, 4) = AUCd{1,q}(k);
        tablica{q}(redni, 5) = RR{1,q}(k);
        tablica{q}(redni, 6) = RRp{1,q}(k);
        tablica{q}(redni, 7) = RRd{1,q}(k);
        tablica{q}(redni, 8) = Ud{1,q}(k);
        redni = redni + 1;

    end
    tablica{q}( ~any(tablica{q},2), : ) = [];
end
c = randperm(length(tablica_n), length(tablica_pvc));
tablica_normal = tablica_n(c,:); %uzima isti broj N kao što je PVC-a
time = toc