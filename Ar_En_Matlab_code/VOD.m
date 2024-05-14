clear all;
close all;
clc;
%%
% You may need to add voicebox (a Matlab toolbox) into your path
code_folder =pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
path_SLA = fullfile(code_folder, "Data\SLA\Normal");
path_Stroke = fullfile(code_folder, "Data\Stroke\Normal");
%%
audio_trim(path_HC);
%%
audio_trim(path_SLA);
%%
audio_trim(path_Stroke);
%%
function audio_trim(path)
    file_csv=fullfile(path, "Normal_csv.csv");
    if exist(file_csv, 'file')
        fileID=fopen(file_csv, "w");
        fclose(fileID);
    end
    
    fileID=fopen(file_csv, "w");
    files = dir(fullfile(path, "*.wav"));
    for i=1:numel(files)
        filename=fullfile(path, files(i).name);
        [y, fs]=audioread(filename);
        vad=vadsohn(y,fs);
            % Concatenate 0s at the beginning and end of vad
        padded_vad = [0; vad; 0];
        
        % Compute differences between consecutive elements
        differences = diff(padded_vad);
        
        % Find indices where differences are equal to 1
        aux = find(differences == 1);
    
        for j = 1:numel(aux)-1
            start_sample = aux(j);
            end_sample = aux(j+1)-1;
            name=strrep(files(i).name, ".wav", "");
            fprintf(fileID, '%s,%d,%d\n', name, start_sample, end_sample);
        end
    end
    fclose(fileID);
end