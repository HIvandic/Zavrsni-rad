function [qrs_amp_raw,qrs_i_raw] = martinez(signal)
fs = 360;
f1 = 12;
f2 = 19; 

%bandpass filter
Wn=[f1 f2]*2/fs;
N = 3;
[a,b] = butter(N,Wn);                       
signal_h = filtfilt(a,b,signal);
signal_h = signal_h/ max(abs(signal_h));

[M, fi] = phasorTransform(signal_h);

threshold = pi/2 - 0.003; 
start = 1;
current_RR = 0;
previous_RR = 0;
size = length(signal_h);

i = 1;
k = 1;
qrs_amp = zeros(4000,1);
qrs_i = zeros(4000,1);
while(i)
    ending = start + 0.3*fs;
    if ending < size
        part = fi(start:ending);
    else
        part = fi(start:size);
        i = 0;
    end
    [y_i,x_i] = max(part);
    x_i = x_i + start;
    
    %korekcija prethodnog RR intervala
    if previous_RR > (1.75 * 0.500 *fs)
        previous_RR = 0.500 *fs;
    end
    
    %provjera je li nadeni maksimum veci od praga
    if y_i > threshold
        if k ~= 1 %ako nije prvi otkriveni moguce usporediti s prosim RR intervalima
            current_RR = x_i - qrs_i(k-1);
            
            %RR interval manji od 40% proslog
            if current_RR < (0.4 * previous_RR)
                if M(qrs_i(k-1)) < M(x_i) %provjera je li amplituda veca
                    qrs_amp(k-1) = fi(x_i);
                    qrs_i(k-1) = x_i;
                    ending = x_i;
                    if k > 2
                        current_RR = x_i - qrs_i(k-2);
                    else 
                        current_RR = 0.500 *fs;
                    end
                else 
                    current_RR = previous_RR;
                end
                             
            %RR interval veci od 175% proslog intervala (propusteni zupci)
            elseif current_RR >= (1.75 * previous_RR)
                start = qrs_i(k-1)+72; %+72 da se osigura razmak od zadnjeg upisanohg R zupca detektiranog iz faze
                ending_w = start + 0.3*fs;
                
                %provjera cijelog intervala (moguce vise preskocenih
                %detekcija)
                while ((ending - 72) > ending_w) %-72 da se osigura razmak od zadnjeg detektiranog R zupca
                    ending_w = start + 0.3*fs;
                    if ending_w < size
                        part = M(start:ending_w);
                    else
                        part = M(start:size);
                    end
                    threshold_w = 0.3 * M(qrs_i(k-1));
                    [y_i_w,x_i_w] = max(part);
                    x_i_w = x_i_w + start;
                    
                    %korekcija prethodnog RR intervala
                    if previous_RR > (1.75 * 0.500 *fs)
                        previous_RR = 0.500 *fs;
                    end
                    
                    %provjera je li nadeni maksimum veci od praga
                    if y_i_w > threshold_w
                        current_RR = x_i_w - qrs_i(k-1);
                        
                        %RR interval manji od 40% proslog
                        if current_RR < (0.4 * previous_RR)
                            if M(qrs_i(k-1)) < M(x_i_w) %provjera je li amplituda veca
                                qrs_amp(k-1) = fi(x_i_w);
                                qrs_i(k-1) = x_i_w;
                                ending_w = x_i_w;
                                if k > 2
                                    current_RR = x_i_w - qrs_i(k-2);
                                else 
                                    current_RR = 0.500 *fs;
                                end
                            else 
                                current_RR = previous_RR;
                            end
                            
                        %RR interval veci od 40% prethodnog
                        else
                            qrs_amp(k) = fi(x_i_w);
                            qrs_i(k) = x_i_w;
                            ending_w = x_i_w;
                            k = k + 1;
                        end
                        previous_RR = current_RR;
                    end
                    start = ending_w;
                end
                %kraj se postavlja na zadnji upisani R zubac detektiran preko amplitude
                %neupisani R zubac detektiran preko faze upisuje se u
                %iducoj iteraciji
                ending = ending_w + 1;
                
            %izmedu 40% i 175% proslog RR intervala
            else
                qrs_amp(k) = y_i;
                qrs_i(k) = x_i;
                ending = x_i;
                k = k + 1;
            end
        else %ako je prvi otkriveni zapis bez usporedbe
            current_RR = 0.500 *fs;
            qrs_amp(k) = y_i;
            qrs_i(k) = x_i;
            ending = x_i;
            k = k + 1;
        end
        previous_RR = current_RR;
        
    %vrijednost je manja od praga, no ni jedan zubac nije otkriven
    elseif k == 1 && x_i > (0.500 *fs)
        part = M(start:ending);
        [y_i,x_i] = max(part);
        x_i = x_i + start;
        qrs_amp(k) = fi(x_i);
        qrs_i(k) = x_i;
        ending = x_i;
        k = k + 1;
        previous_RR = 0.500 *fs;
    end
    start = ending + 1;
end

%upis u matricu odgovarajucih dimenzija
qrs_amp_raw = zeros(k-1, 1);
qrs_i_raw = zeros(k-1, 1);
for i = 1 : (k-1)
    qrs_amp_raw(i) = qrs_amp(i);
    qrs_i_raw(i) = qrs_i(i);
end
    