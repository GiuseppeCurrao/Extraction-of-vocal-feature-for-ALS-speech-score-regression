clear all;
close all;
clc;
%% BBP voice recording
%computation of the entropy with the three different segmentation method

code_folder =pwd;

path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
csv_HC = readtable("Healthy Control\Normal.csv");
csv_HC_vad = readtable("Healthy Control\Normal\table.csv");
csv_HC_vad_th = readtable("Healthy Control\Normal\table_th.csv");

path_SLA = fullfile(code_folder, "Data\SLA\Normal");
csv_SLA = readtable("SLA\Normal.csv");
csv_SLA_vad = readtable("SLA\Normal\table.csv");
csv_SLA_vad_th = readtable("SLA\Normal\table_th.csv");
%% Articulation entropy for the three segmentation methods
% Only the vosk method is used for regression

ae_HC=ae_extraction(path_HC, csv_HC,10,5);
ae_SLA=ae_extraction(path_SLA,csv_SLA,10,5);

ae_HC_vad=ae_extraction(path_HC, csv_HC_vad,10,5);
ae_SLA_vad=ae_extraction(path_SLA, csv_SLA_vad,10,5);

ae_HC_vad_th=ae_extraction(path_HC, csv_HC_vad_th,10,5);
ae_SLA_vad_th=ae_extraction(path_SLA, csv_SLA_vad_th,10,5);
%% Computation of mean and std of AE for the different segmentation method
% This value show strange behaviour for VAD. This features are not used in
% the regression

[mn_HC, std_HC]=compute_mean_std(ae_HC);
[mn_HC_vad, std_HC_vad]=compute_mean_std(ae_HC_vad);
[mn_HC_vad_th, std_HC_vad_th]=compute_mean_std(ae_HC_vad_th);

[mn_SLA, std_SLA]=compute_mean_std(ae_SLA);
[mn_SLA_vad, std_SLA_vad]=compute_mean_std(ae_SLA_vad);
[mn_SLA_vad_th, std_SLA_vad_th]=compute_mean_std(ae_SLA_vad_th);
%% Scatterplot AE/WER

[count, countS] = count_csv(csv_HC,csv_SLA);
figure;
subplot(2,4,[1 2]);
sz=80;
mean_hc_wr = [];
mean_sla_wr = [];
sum=1;
hold on
for i=1:size(ae_HC,1)
    ind=find(ae_HC(i,:)~=0);
    aux = ae_HC(i, ind);
    yaux = csv_HC{sum:sum+count(i)-1,4};
    mean_hc_wr(i)= mean(yaux);
    scatter_HC = scatter(mean(aux), mean(yaux),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
    sum=sum+count(i);
end
sum=1;
for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    aux = ae_SLA(i, ind);
    yaux = csv_SLA{sum:sum+countS(i)-1,4};
    mean_sla_wr(i)=mean(yaux);
    scatter_SLA = scatter(mean(aux), mean(yaux),sz, "red","filled");
    sum=sum+countS(i);
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "ALS");
ylabel("Confidence");
xlabel("Articolation Entropy Vosk");
title("Scatterplot for BBP files using VOSK")

mean_hc_wr = [mean_hc_wr(1:7), 1, mean_hc_wr(8:9)];
sz=80;
subplot(2,4,[3 4]);
hold on
for i=1:size(ae_HC_vad,1)
    ind=find(ae_HC_vad(i,:)~=0);
    aux = ae_HC_vad(i, ind);
    ind=find(aux(:)~=-1);
    aux=aux(ind);
    scatter_HC = scatter(mean(aux), mean_hc_wr(i),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end

for i=1:size(ae_SLA_vad,1)
    ind=find(ae_SLA_vad(i,:)~=0);
    aux = ae_SLA_vad(i, ind);
    ind=find(aux(:)~=-1);
    aux=aux(ind);
    scatter_SLA = scatter(mean(aux), mean_sla_wr(i),sz, "red","filled");
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "ALS");
ylabel("Confidence");
xlabel("Articolation Entropy VAD");
title("Scatterplot for BBP files using VAD")

sz=80;
subplot(2,4,[6 7]);
hold on
for i=1:size(ae_HC_vad_th,1)
    ind=find(ae_HC_vad_th(i,:)~=0);
    aux = ae_HC_vad(i, ind);
    ind=find(aux~=-1);
    aux=aux(ind);
    scatter_HC = scatter(mean(aux), mean_hc_wr(i),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end

for i=1:size(ae_SLA_vad_th,1)
    ind=find(ae_SLA_vad_th(i,:)~=0);
    aux = ae_SLA_vad(i, ind);
    ind=find(aux~=-1);
    aux=aux(ind);
    scatter_SLA = scatter(mean(aux), mean_sla_wr(i),sz, "red","filled");
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "ALS");
ylabel("Confidence");
xlabel("Articolation Entropy VAD with threshold");
title("Scatterplot for BBP files using VAD thresholded")
%% Scatterplot Confidence/WER
%Computed only over VOSK

[count, countS] = count_csv(csv_HC,csv_SLA);
figure;
hold on
for i=1:size(ae_HC,1)
    aux = csv_HC{(i-1)*count(i)+1:(i)*count(i),4};
    yaux = csv_HC{(i-1)*count(i)+1:(i)*count(i),5};
    scatter_HC=scatter(mean(aux), mean(yaux),sz, "filled", "red");
end

for i=1:size(ae_SLA,1)
    aux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),4};
    yaux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),5};
    scatter_SLA=scatter(mean(aux), mean(yaux),sz,"blue", "filled");
end
legend([scatter_HC, scatter_SLA],"HC", "ALS");
ylabel("Word Error Rate");
xlabel("Confidence");
title("Scatterplot for BBP files using VOSK")

%% This plot show the different activation ratio 
%WARNING: These values have not been used in the regression

ar_HC=activation_ratio(path_HC, csv_HC_vad,csv_HC_vad_th,csv_HC);
ar_SLA=activation_ratio(path_SLA,csv_SLA_vad,csv_SLA_vad_th,csv_SLA);

data = [mean(ar_HC,2), mean(ar_SLA,2)];
bar(data);
labels = {'VAD', 'VAD with threshold', 'Vosk'};

set(gca, 'XTickLabel', labels);

xlabel('Segmentation methods');
ylabel('Mean activation ratio');
legend("HC", "ALS");
%% Activation frequency
%WARNING: These values have not been used in the regression

af_HC=activation_frequency(path_HC, csv_HC_vad,csv_HC_vad_th,csv_HC);
af_SLA=activation_frequency(path_SLA,csv_SLA_vad,csv_SLA_vad_th,csv_SLA);

data = [mean(af_HC,2), mean(af_SLA,2)];
bar(data);
labels = {'VAD', 'VAD with threshold', 'Vosk'};

set(gca, 'XTickLabel', labels);

xlabel('Segmentation methods');
ylabel('Mean activation frequency');
legend("HC", "SLA");
%% Boxplot Articulation entropy

boxae(ae_HC, ae_SLA, "VOSK", code_folder);
% boxae(ae_HC_vad, ae_SLA_vad, "VAD", code_folder);
% boxae(ae_HC_vad_th, ae_SLA_vad_th, "VAD with th",code_folder);
%% Boxplot confidence

figure('Position', [100, 100, 1200, 800])
hold on
boxplot([csv_HC{:,4}; csv_SLA{:,4}], [zeros(size(csv_HC,1),1); 1+zeros(size(csv_SLA,1),1)]);
labels = {'HC', 'ALS'};
set(gca, 'XTickLabel', labels);
ylabel('Confidence');
title("Confidence");
[p, h, stats] = ranksum(csv_HC{:,4}, csv_SLA{:,4});
num_asterisks = '';
if h == 1
    if p < 0.001
        num_asterisks = '***';
    elseif p < 0.01
        num_asterisks = '**';
    elseif p < 0.05
        num_asterisks = '*';
    end
end
if ~isempty(num_asterisks)
    
    max_y = max([csv_HC{:,4}; csv_SLA{:,4}]);
    line([1, 2], [max_y + 0.05, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);
    line([1, 1], [max_y + 0.04, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);
    line([2, 2], [max_y + 0.04, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);

   
    text(1.5, max_y + 0.07, num_asterisks, 'HorizontalAlignment', 'center', 'FontSize', 16);
end
xlim([0, 3]);
ylim([min([csv_HC{:,4}; csv_SLA{:,4}]) max([csv_HC{:,4}; csv_SLA{:,4}]) + 0.1]);

saveas(gcf, fullfile(code_folder,"Figures\Confidence.png"));
hold off
%% Boxplot WER

figure('Position', [100, 100, 1200, 800])
hold on
boxplot([csv_HC{:,5}; csv_SLA{:,5}], [zeros(size(csv_HC,1),1); 1+zeros(size(csv_SLA,1),1)]);
labels = {'HC', 'ALS'};
set(gca, 'XTickLabel', labels);
ylabel('Word Error Rate');
title("Word Error Rate");
[p, h, stats]  = ranksum(csv_HC{:,5}, csv_SLA{:,5});
num_asterisks = '';
if h == 1
    if p < 0.001
        num_asterisks = '***';
    elseif p < 0.01
        num_asterisks = '**';
    elseif p < 0.05
        num_asterisks = '*';
    end
end
if ~isempty(num_asterisks)
    
    max_y = max([csv_HC{:,5}; csv_SLA{:,5}]);
    line([1, 2], [max_y + 0.05, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);
    line([1, 1], [max_y + 0.04, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);
    line([2, 2], [max_y + 0.04, max_y + 0.05], 'Color', 'k', 'LineWidth', 0.7);

    text(1.5, max_y + 0.07, num_asterisks, 'HorizontalAlignment', 'center', 'FontSize', 16);
end
xlim([0, 3]);
ylim([min([csv_HC{:,5}; csv_SLA{:,5}]) max([csv_HC{:,5}; csv_SLA{:,5}]) + 0.1]);

saveas(gcf, fullfile(code_folder,"Figures\Word Error Rate.png"));

%% Function used to compute the AE mean without considering errors

function [m, s] = compute_mean_std(ar)
    m=[];
    s=[];
    for i=1:size(ar,1)
        ind=find(ar(i,:)~=0);
        aux=ar(i,ind);
        ind=find(aux(:)~=-1);
        ax=aux(ind);
        m=[m mean(ax(:))];
        s=[s std(ax)];
    end   
end
%% Function used to count the number of segment per audio files

function [count, countS] = count_csv(csv_HC, csv_SLA)
    count=[];
    countS=[];
    str="";
    j=0;
    for i=1:size(csv_HC,1)
        file_name=string(csv_HC{i,1});
        if ~strcmp(str,file_name)
            j=j+1;
            count(j)=1;
            str=file_name;
        else
            count(j)=count(j)+1;
        end
    end
    j=0;
    for i=1:size(csv_SLA,1)
        file_name=string(csv_SLA{i,1});
        if ~strcmp(str,file_name)
            j=j+1;
            countS(j)=1;
            str=file_name;
        else
            countS(j)=countS(j)+1;
        end
    end
end
%% function to create boxplot. Used for ae

function [] = boxae(ae_hc, ae_sla, name, folder)
    ind = find(ae_hc~=0);
    ae=ae_hc(ind);
    ind = find(ae~=-1);
    ae=ae(ind);
    ae=ae(:);

    ind=find(ae_sla~=0);
    ae_s= ae_sla(ind);
    ind=find(ae_s~=-1);
    ae_s=ae_s(ind);
    ae_s=ae_s(:);

    path = fullfile(folder, "Figures\");
    file_name = sprintf("Boxplot of articulation entropy for %s segmentation", name);
    file_path = fullfile(path, file_name);
    file_path = strcat(file_path, '.png');
    
    figure('Position', [100, 100, 1200, 800]);
    boxplot([ae(:); ae_s(:)], [zeros(size(ae,1),1); 1+zeros(size(ae_s,1),1)]);
    title(file_name);
    labels = {'HC', 'ALS'};
    set(gca, 'XTickLabel', labels);
    ylabel('Articulation Entropy');
    [p, h, stats] = ranksum(ae, ae_s);
    num_asterisks = '';
    if h == 1
        if p < 0.001
            num_asterisks = '***';
        elseif p < 0.01
            num_asterisks = '**';
        elseif p < 0.05
            num_asterisks = '*';
        end
    end
    if ~isempty(num_asterisks)
        
        max_y = max([ae(:); ae_s(:)]);
        line([1, 2], [max_y + 7, max_y + 7], 'Color', 'k', 'LineWidth', 0.7);
        line([1, 1], [max_y + 5, max_y + 7], 'Color', 'k', 'LineWidth', 0.7);
        line([2, 2], [max_y + 5, max_y + 7], 'Color', 'k', 'LineWidth', 0.7);
    
        
        text(1.5, max_y + 10, num_asterisks, 'HorizontalAlignment', 'center', 'FontSize', 16);
    end
    xlim([0, 3]);
    ylim([min([ae(:); ae_s(:)]) max([ae(:); ae_s(:)]) + 15]);

    saveas(gcf, file_path);
end