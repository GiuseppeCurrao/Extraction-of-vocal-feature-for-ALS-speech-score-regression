clear all;
close all;
clc;
%%
% You may need to add voicebox (a Matlab toolbox) into your path
code_folder =pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
path_SLA = fullfile(code_folder, "Data\SLA\Normal");
path_Stroke = fullfile(code_folder, "Data\Stroke\Normal");
path_HC_PA=fullfile(code_folder, "Data\Healthy Control\PA");
path_SLA_PA=fullfile(code_folder, "Data\SLA\PA");
path_Stroke_PA=fullfile(code_folder, "Data\Stroke\PA");
%%
audio_trim(path_HC,1);
audio_trim(path_SLA,1);
audio_trim(path_Stroke,1);
%%
audio_trim(path_HC,2);
audio_trim(path_SLA,2);
audio_trim(path_Stroke,2);
%%
audio_trim(path_HC_PA,1);
audio_trim(path_SLA_PA,1);
audio_trim(path_Stroke_PA,1);
%%
audio_trim(path_HC_PA,2);
audio_trim(path_SLA_PA,2);
audio_trim(path_Stroke_PA,2);
%%
function audio_trim(path,f)
    if f==1
        file_csv=fullfile(path, "table.csv");
    else
        file_csv=fullfile(path, "table_th.csv");
    end
    if exist(file_csv, 'file')
        fileID=fopen(file_csv, "w");
        fclose(fileID);
    end
    
    fileID=fopen(file_csv, "w");
    files = dir(fullfile(path, "*.wav"));
    for i=1:numel(files)
        filename=fullfile(path, files(i).name);
        [y, fs]=audioread(filename);
        th=2*std(y);

        vad=vadsohn(y,fs);

            % Concatenate 0s at the beginning and end of vad
        padded_vad = [0; vad; 0];
        
        % Compute differences between consecutive elements
        differences = abs(diff(padded_vad));
        
        % Find indices where differences are equal to 1
        aux = find(differences == 1);
    
        for j = 1:2:numel(aux)-1
            start_sample = aux(j);
            end_sample = aux(j+1)-1;
            if f==2
                if max(y(start_sample:end_sample))>=th
                    name=strrep(files(i).name, ".wav", "");
                    fprintf(fileID, '%s,%d,%d\n', name, start_sample, end_sample);
                end
            else
                name=strrep(files(i).name, ".wav", "");
                fprintf(fileID, '%s,%d,%d\n', name, start_sample, end_sample);
            end
        end
    end
    fclose(fileID);
end