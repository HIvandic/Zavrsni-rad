tic
%pretvaranje u matricu
txt = dir('*.txt');
beatAnotacije = zeros(20,48);
anotacije = cell(1, 48);
for q = 1:length(txt)
    fid = fopen(txt(q).name,'rt');
    fid2 = fopen(txt(q).name,'rt');
    fgets(fid2); %red s naslovima
    velicina=-1; %zbog reda s naslovima
    while (fgets(fid)  ~= -1) 
        velicina = velicina +1;
    end
    br = 1;
    for i = 1:velicina
        line = fgets(fid2);
        pom = strtrim(line);
        pom = regexprep(pom,' +',' ');
        razdvojeno = split(pom, " ");
        rez = str2double(razdvojeno(2, 1));
        beat = char(razdvojeno(3,1));
        switch beat
            case 'N'
                beatAnotacije(1,q) = beatAnotacije(1,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case '.'
                beatAnotacije(1,q) = beatAnotacije(1,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'L'
                beatAnotacije(2,q) = beatAnotacije(2,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'R'
                beatAnotacije(3,q) = beatAnotacije(3,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'B'
                beatAnotacije(4,q) = beatAnotacije(4,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'A'
                beatAnotacije(5,q) = beatAnotacije(5,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'a'
                beatAnotacije(6,q) = beatAnotacije(6,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'J'
                beatAnotacije(7,q) = beatAnotacije(7,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'S'
                beatAnotacije(8,q) = beatAnotacije(8,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'V'
                beatAnotacije(9,q) = beatAnotacije(9,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'r'
                beatAnotacije(10,q) = beatAnotacije(10,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'F'
                beatAnotacije(11,q) = beatAnotacije(11,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'e'
                beatAnotacije(12,q) = beatAnotacije(12,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'j'
                beatAnotacije(13,q) = beatAnotacije(13,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'n'
                beatAnotacije(14,q) = beatAnotacije(14,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'E'
                beatAnotacije(15,q) = beatAnotacije(15,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case '/'
                beatAnotacije(16,q) = beatAnotacije(16,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'f'
                beatAnotacije(17,q) = beatAnotacije(17,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case 'Q'
                beatAnotacije(18,q) = beatAnotacije(18,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
            case '?'
                beatAnotacije(19,q) = beatAnotacije(19,q)+1;
                beatAnotacije(20,q) = beatAnotacije(20,q)+1;
                anotacije{1,q}(br, 1) = rez;
                anotacije{1,q}(br, 2) = beat;
                br = br + 1;
        end
    end
end   
time = toc