clear all;
close all;
clc;
%%
code_folder =pwd;

path_HC_Normal = fullfile(code_folder, "Data\Healthy Control\Normal");
path_HC_PA = fullfile(code_folder, "Data\Healthy Control\PA");
path_HC_PATAKA = fullfile(code_folder, "Data\Healthy Control\PATAKA");

path_SLA_Normal = fullfile(code_folder, "Data\SLA\Normal");
path_SLA_PA = fullfile(code_folder, "Data\SLA\PA");
path_SLA_PATAKA = fullfile(code_folder, "Data\SLA\PATAKA");

path_Stroke_Normal = fullfile(code_folder, "Data\Stroke\Normal");
path_Stroke_PA = fullfile(code_folder, "Data\Stroke\PA");
path_Stroke_PATAKA = fullfile(code_folder, "Data\Stroke\PATAKA");
%%
files = dir(fullfile(path_HC_Normal, "*.wav"));
mkdir(fullfile(path_HC_Normal, "MATLAB"));
mpath = fullfile(path_HC_Normal, "MATLAB");
%%
for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_HC_Normal, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end
%%
files = dir(fullfile(path_HC_PA, "*.wav"));
mkdir(fullfile(path_HC_PA, "MATLAB"));
mpath = fullfile(path_HC_PA, "MATLAB");
%%
for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_HC_PA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end
%%
files = dir(fullfile(path_HC_PATAKA, "*.wav"));
mkdir(fullfile(path_HC_PATAKA, "MATLAB"));
mpath = fullfile(path_HC_PATAKA, "MATLAB");
%%
for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_HC_PATAKA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end
%%
files = dir(fullfile(path_SLA_Normal, "*.wav"));
mkdir(fullfile(path_SLA_Normal, "MATLAB"));
mpath = fullfile(path_SLA_Normal, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_SLA_Normal, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end

files = dir(fullfile(path_SLA_PA, "*.wav"));
mkdir(fullfile(path_SLA_PA, "MATLAB"));
mpath = fullfile(path_SLA_PA, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_SLA_PA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end

files = dir(fullfile(path_SLA_PATAKA, "*.wav"));
mkdir(fullfile(path_SLA_PATAKA, "MATLAB"));
mpath = fullfile(path_SLA_PATAKA, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_SLA_PATAKA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end
%%
files = dir(fullfile(path_Stroke_Normal, "*.wav"));
mkdir(fullfile(path_Stroke_Normal, "MATLAB"));
mpath = fullfile(path_Stroke_Normal, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_Stroke_Normal, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end

files = dir(fullfile(path_Stroke_PA, "*.wav"));
mkdir(fullfile(path_Stroke_PA, "MATLAB"));
mpath = fullfile(path_Stroke_PA, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_Stroke_PA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end

files = dir(fullfile(path_Stroke_PATAKA, "*.wav"));
mkdir(fullfile(path_Stroke_PATAKA, "MATLAB"));
mpath = fullfile(path_Stroke_PATAKA, "MATLAB");

for i =1:numel(files)
    file_name = files(i).name;
    file_path=fullfile(path_Stroke_PATAKA, file_name);
    mfile_path = fullfile(mpath, file_name);
    mkdir(mfile_path);

    trim_audio(file_path, mfile_path);
end
%%
function trim_audio(file, path)
    [y,fs] = audioread(file);
    vad = vadsohn(y,fs);
    % Concatenate 0s at the beginning and end of vad
    padded_vad = [0; vad; 0];
    
    % Compute differences between consecutive elements
    differences = diff(padded_vad);
    
    % Find indices where differences are equal to 1
    aux = find(differences == 1);

    for i = 1:numel(aux)-1
    start_sample = aux(i);
    end_sample = aux(i+1)-1;
    
    % Extract the segment from the audio data
    segment_data = y(start_sample:end_sample);
    
    % Normalize the segment (optional)
    segment_data = segment_data / max(abs(segment_data));
    
    % Save the segment as a separate audio file
    filename = sprintf('%s\\segment_%d.wav',path, i);
    audiowrite(filename, segment_data, fs);
    end
end