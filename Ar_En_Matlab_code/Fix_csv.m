%% File to fix the parameter csv, removing all the files related to not studied patients
clear all;
close all;
clc;
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
        if contains(lower(name),lower(hc_w{j,1}))
            if ~contains(lower(name),'pataka') || (contains(lower(name), 'pataka') && contains(lower(hc_w{j,1}), 'pataka'))
                k=1;
            end
        end
    end
    if k==0
        csv{i,1}
        ind=[ind, i];
    end
end
csv(ind,:)=[];
for i=1:size(csv,1)
    csv{i,1}=strrep(csv{i,1}, '_color.avi', '');
end
%%
file_csv=fullfile(HC_f, "params.csv");
if exist(file_csv, 'file')
    fileID=fopen(file_csv, "w");
    fclose(fileID);
end    
writetable(csv, file_csv);
%%
ind=[];
for i=1:size(csv_sla,1)
    k=0;
    for j=1:size(sla_w,1)
        [~, name, ex] = fileparts(csv_sla{i,1});
        if contains(sla_w{j,1}, '_al')
            sla_w{j,1}=strrep(sla_w{j,1},'_al','');
        end
        if contains(lower(name),lower(sla_w{j,1}))
            if ~contains(lower(name),'pataka') || (contains(lower(name), 'pataka') && contains(lower(sla_w{j,1}), 'pataka'))
            k=1;
            end
        end
    end
    if k==0
        ind=[ind, i];
    end
end
csv_sla(ind,:)=[];
for i=1:size(csv_sla,1)
    csv_sla{i,1}=strrep(csv_sla{i,1}, '_color.avi', '');
end
%%
file_csv=fullfile(SLA_f, "params.csv");
if exist(file_csv, 'file')
    fileID=fopen(file_csv, "w");
    fclose(fileID);
end    
writetable(csv_sla, file_csv);
%%
function wavFiles = getAllWavFiles(folder)
    % Initialise a cell array to store file names
    wavFiles = {};
    
    % Get a list of all files and folders in the current directory
    filesAndDirs = dir(folder);
    
    % Remove pointers to folders '.' and '...'.
    filesAndDirs = filesAndDirs(~ismember({filesAndDirs.name}, {'.', '..'}));
    
    % Iterate through the elements in the current directory
    for i = 1:length(filesAndDirs)
        % Get the full name
        fullPath = fullfile(folder, filesAndDirs(i).name);
        
        % Verify if it is a folder
        if filesAndDirs(i).isdir
            % If it is, explore it
            wavFiles = [wavFiles; getAllWavFiles(fullPath)];
        else
            % Verify if it is a .wav file
            [~, ~, ext] = fileparts(fullPath);
            if strcmpi(ext, '.wav')
                % Add it to the list
                [~, baseFileName, extension] = fileparts(fullPath);
                wavFiles = [wavFiles; {baseFileName}];
            end
        end
    end
end