clear all;
close all;
clc
%%
csv=readtable("Data\SLP_Assessment_HC.xlsx");
csv_sla=readtable("Data\SLP_Assessment_ALS.xlsx");
%%
fold=pwd;
HC_f=fullfile(fold,"Data\Healthy Control");
SLA_f=fullfile(fold,"Data\SLA");
%%
hc_w=getAllWavFiles(HC_f);
sla_w=getAllWavFiles(SLA_f);
%%
ind=[];
for i=1:size(csv,1)
    k=0;
    for j=1:size(hc_w,1)
        [~, name, ex] = fileparts(csv{i,1});
        name=strrep(name, '_color', '');
        if strcmp(name,hc_w{j,1})
            k=1;
        end
    end
    if k==0
        ind=[ind, i];
    end
end
csv(ind,:)=[];
for i=1:size(csv,1)
    csv{i,1}=strrep(csv{i,1}, '_color.avi', '');
end
%%
ind=[];
for i=1:size(csv_sla,1)
    k=0;
    for j=1:size(sla_w,1)
        [~, name, ex] = fileparts(csv_sla{i,1});
        name=strrep(name, '_color', '');
        if strcmp(name,sla_w{j,1})
            k=1;
        end
    end
    if k==0
        ind=[ind, i];
    end
end
csv_sla(ind,:)=[];
for i=1:size(csv_sla,1)
    csv_sla{i,1}=strrep(csv{i,1}, '_color.avi', '');
end
%%
function wavFiles = getAllWavFiles(folder)
    % Inizializza una cell array per memorizzare i nomi dei file
    wavFiles = {};
    
    % Ottieni l'elenco di tutti i file e cartelle nella directory corrente
    filesAndDirs = dir(folder);
    
    % Rimuovi i puntatori alle cartelle '.' e '..'
    filesAndDirs = filesAndDirs(~ismember({filesAndDirs.name}, {'.', '..'}));
    
    % Itera attraverso gli elementi nella directory corrente
    for i = 1:length(filesAndDirs)
        % Ottieni il nome completo del file o della cartella
        fullPath = fullfile(folder, filesAndDirs(i).name);
        
        % Verifica se è una cartella
        if filesAndDirs(i).isdir
            % Chiamata ricorsiva per esplorare la cartella
            wavFiles = [wavFiles; getAllWavFiles(fullPath)];
        else
            % Verifica se è un file .wav
            [~, ~, ext] = fileparts(fullPath);
            if strcmpi(ext, '.wav')
                % Aggiungi il file .wav alla lista
                [~, baseFileName, extension] = fileparts(fullPath);
                wavFiles = [wavFiles; {baseFileName}];
            end
        end
    end
end