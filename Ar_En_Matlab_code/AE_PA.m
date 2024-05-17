clear all;
close all;
clc;
%%
% You may need to add voicebox (a Matlab toolbox) into your path
code_folder =pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\PA");
csv_HC = readtable("Healthy Control\PA\table.csv");
path_SLA = fullfile(code_folder, "Data\SLA\PA");
csv_SLA = readtable("SLA\PA\table.csv");
path_Stroke = fullfile(code_folder, "Data\Stroke\PA");
csv_Stroke = readtable("Stroke\PA\table.csv");
