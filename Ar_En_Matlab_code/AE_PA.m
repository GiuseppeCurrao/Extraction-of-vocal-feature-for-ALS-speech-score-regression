clear all;
close all;
clc;
%% Elaboration of PA files
code_folder = pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\PA");
csv_HC = readtable("Healthy Control\PA\table.csv");
csv_HC_th = readtable("Healthy Control\PA\table_th.csv");

path_SLA = fullfile(code_folder, "Data\SLA\PA");
csv_SLA = readtable("SLA\PA\table.csv");
csv_SLA_th = readtable("SLA\PA\table_th.csv");
%%
ar_HC=activation_ratio(path_HC, csv_HC, csv_HC_th);
ar_SLA=activation_ratio(path_SLA, csv_SLA,csv_SLA_th);
%%
af_HC=activation_frequency(path_HC,csv_HC, csv_HC_th);
af_SLA=activation_frequency(path_SLA,csv_SLA, csv_SLA_th);
%% not used
% ae_HC = ae_extraction(path_HC, csv_HC);
% ae_HC_th = ae_extraction(path_HC, csv_HC_th);
% 
% ae_SLA = ae_extraction(path_SLA, csv_SLA);
% ae_SLA_th = ae_extraction(path_SLA, csv_SLA_th);
%% Scatterplot
figure
hold on
scatter(af_HC(1,:),ar_HC(1,:),"red", "filled");
scatter(af_SLA(1,:), ar_SLA(1,:),"blue","filled");
title("Without treshold, PA files")
xlabel("Activation Frequency")
ylabel("Activation Ratio")
legend("HC", "SLA")
hold off
saveas(gcf, fullfile(code_folder, "Figures\Scatterplot_AR_over_AF_PA.png"));

figure
hold on
scatter(af_HC(2,:),ar_HC(2,:),"red", "filled");
scatter(af_SLA(2,:), ar_SLA(2,:),"blue","filled");
title("With treshold, PA files")
xlabel("Activation Frequency")
ylabel("Activation Ratio")
legend("HC", "SLA")
hold off

saveas(gcf, fullfile(code_folder, "Figures\Scatterplot_AR_over_AF_PA_w_th.png"));
%% Boxplots
figure
boxplot([ar_HC(1,:)'; ar_SLA(1,:)'], [zeros(10,1); 1+zeros(9,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Ratio');
title("Activation Ratio of PA files without threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Ratio_PA.png"));

figure
boxplot([ar_HC(2,:)'; ar_SLA(2,:)'], [zeros(10,1); 1+zeros(9,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Ratio');
title("Activation Ratio of PA files with threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Ratio_PA_w_th.png"));

figure
boxplot([af_HC(1,:)'; af_SLA(1,:)'], [zeros(10,1); 1+zeros(9,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Frequency');
title("Activation Frequency of PA files without threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Frequency_PA.png"));

figure
boxplot([af_HC(2,:)'; af_SLA(2,:)'], [zeros(10,1); 1+zeros(9,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Frequency');
title("Activation Frequency of PA files with threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Frequency_PA_w_th.png"));
%% Elaboration of PATAKA files
path_HC = fullfile(code_folder, "Data\Healthy Control\PATAKA");
csv_HC = readtable("Healthy Control\PATAKA\table.csv");
csv_HC_th = readtable("Healthy Control\PATAKA\table_th.csv");

path_SLA = fullfile(code_folder, "Data\SLA\PATAKA");
csv_SLA = readtable("SLA\PATAKA\table.csv");
csv_SLA_th = readtable("SLA\PATAKA\table_th.csv");
%%
ar_HC=activation_ratio(path_HC, csv_HC, csv_HC_th);
ar_SLA=activation_ratio(path_SLA, csv_SLA,csv_SLA_th);
%%
af_HC=activation_frequency(path_HC,csv_HC, csv_HC_th);
af_SLA=activation_frequency(path_SLA,csv_SLA, csv_SLA_th);
%% Not used
% ae_HC = ae_extraction(path_HC, csv_HC);
% ae_HC_th = ae_extraction(path_HC, csv_HC_th);
% 
% ae_SLA = ae_extraction(path_SLA, csv_SLA);
% ae_SLA_th = ae_extraction(path_SLA, csv_SLA_th);
%%
figure
hold on
scatter(af_HC(1,:),ar_HC(1,:),"red", "filled");
scatter(af_SLA(1,:), ar_SLA(1,:),"blue","filled");
title("Without treshold, PATAKA files")
xlabel("Activation Frequency")
ylabel("Activation Ratio")
legend("HC", "SLA")
hold off
saveas(gcf, fullfile(code_folder, "Figures\Scatterplot_AR_over_AF_PATAKA.png"));

figure
hold on
scatter(af_HC(2,:),ar_HC(2,:),"red", "filled");
scatter(af_SLA(2,:), ar_SLA(2,:),"blue","filled");
title("With treshold, PATAKA files")
xlabel("Activation Frequency")
ylabel("Activation Ratio")
legend("HC", "SLA")
hold off

saveas(gcf, fullfile(code_folder, "Figures\Scatterplot_AR_over_AF_PATAKA_w_th.png"));
%% Boxplots
figure
boxplot([ar_HC(1,:)'; ar_SLA(1,:)'], [zeros(11,1); 1+zeros(8,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Ratio');
title("Activation Ratio of PATAKA files without threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Ratio_PATAKA.png"));

figure
boxplot([ar_HC(2,:)'; ar_SLA(2,:)'], [zeros(11,1); 1+zeros(8,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Ratio');
title("Activation Ratio of PATAKA files with threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Ratio_PATAKA_w_th.png"));

figure
boxplot([af_HC(1,:)'; af_SLA(1,:)'], [zeros(11,1); 1+zeros(8,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Frequency');
title("Activation Frequency of PATAKA files without threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Frequency_PATAKA.png"));

figure
boxplot([af_HC(2,:)'; af_SLA(2,:)'], [zeros(11,1); 1+zeros(8,1)]);
labels = {'HC', 'SLA'};
set(gca, 'XTickLabel', labels);
ylabel('Activation Frequency');
title("Activation Frequency of PATAKA files with threshold");
saveas(gcf, fullfile(code_folder,"Figures\Activation_Frequency_PATAKA_w_th.png"));
