close all
clear all
clc
%% Creation of the csv used for the regression

code_folder=pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
path_SLA = fullfile(code_folder, "Data\SLA\Normal");

% csv containing the scores of the patients
csv_params_hc = readtable(fullfile(code_folder, "Data\Healthy Control\params.csv"));
csv_params_sla = readtable(fullfile(code_folder,"Data\SLA\params.csv"));

% csv containing the time-frames of voice activation

csv_hc_vosk = readtable(fullfile(code_folder, "Data\Healthy Control\Normal.csv"));
csv_hc_vad = readtable(fullfile(code_folder, "Data\Healthy Control\Normal\table.csv"));
csv_hc_vad_th = readtable(fullfile(code_folder, "Data\Healthy Control\Normal\table_th.csv"));

csv_sla_vosk = readtable(fullfile(code_folder, "Data\SLA\Normal.csv"));
csv_sla_vad = readtable(fullfile(code_folder, "Data\SLA\Normal\table.csv"));
csv_sla_vad_th = readtable(fullfile(code_folder, "Data\SLA\Normal\table_th.csv"));

%% Extrapolation of parameters for the BBP files
% Articulation Entropy
ae_hc = ae_extraction(path_HC, csv_hc_vosk, 10,5);
ae_sla = ae_extraction(path_SLA, csv_sla_vosk, 10, 5);