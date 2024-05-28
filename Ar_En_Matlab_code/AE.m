clear all;
close all;
clc;
%% Normal voice recording
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
ae_HC=ae_extraction(path_HC, csv_HC,10,5);
ae_SLA=ae_extraction(path_SLA,csv_SLA,10,5);

ae_HC_vad=ae_extraction(path_HC, csv_HC_vad,10,5);
ae_SLA_vad=ae_extraction(path_SLA, csv_SLA_vad,10,5);

ae_HC_vad_th=ae_extraction(path_HC, csv_HC_vad_th,10,5);
ae_SLA_vad_th=ae_extraction(path_SLA, csv_SLA_vad_th,10,5);
%%
mea_HC=compute_mean(ae_HC);
mea_HC_vad=compute_mean(ae_HC_vad);
mea_HC_vad_th=compute_mean(ae_HC_vad_th);

mea_SLA=compute_mean(ae_SLA);
mea_SLA_vad=compute_mean(ae_SLA_vad);
mea_SLA_vad_th=compute_mean(ae_SLA_vad_th);
%%
[count, countS] = count_csv(csv_HC,csv_SLA);
figure;
sz=80;
mean_hc_wr = [];
mean_sla_wr = [];

hold on
for i=1:size(ae_HC,1)
    ind=find(ae_HC(i,:)~=0);
    aux = ae_HC(i, ind);
    yaux = csv_HC{(i-1)*count(i)+1:(i)*count(i),4};
    mean_hc_wr(i)= mean(yaux);
    scatter_HC = scatter(mean(aux), mean(yaux),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end

for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    aux = ae_SLA(i, ind);
    yaux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),4};
    mean_sla_wr(i)=mean(yaux);
    scatter_SLA = scatter(mean(aux), mean(yaux),sz, "red","filled");
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "SLA");
ylabel("Word Error Rate");
xlabel("Articolation Entropy Vosk");
title("Scatterplot for BBP files using VOSK")
%%
[count, countS] = count_csv(csv_HC_vad, csv_SLA_vad); 
mean_hc_wr = [mean_hc_wr(1:7), 1, mean_hc_wr(8:9)];
figure;
sz=80;
hold on
for i=1:size(ae_HC_vad,1)
    ind=find(ae_HC_vad(i,:)~=0);
    aux = ae_HC_vad(i, ind);
    scatter_HC = scatter(mean(aux), mean_hc_wr(i),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end

for i=1:size(ae_SLA_vad,1)
    ind=find(ae_SLA_vad(i,:)~=0);
    aux = ae_SLA_vad(i, ind);
    scatter_SLA = scatter(mean(aux), mean_sla_wr(i),sz, "red","filled");
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "SLA");
ylabel("Word Error Rate");
xlabel("Articolation Entropy VAD");
title("Scatterplot for BBP files using VAD")
%%
[count, countS] = count_csv(csv_HC_vad_th, csv_SLA_vad_th); 
figure;
sz=80;
hold on
for i=1:size(ae_HC_vad_th,1)
    ind=find(ae_HC_vad_th(i,:)~=0);
    aux = ae_HC_vad(i, ind);
    scatter_HC = scatter(mean(aux), mean_hc_wr(i),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end

for i=1:size(ae_SLA_vad_th,1)
    ind=find(ae_SLA_vad_th(i,:)~=0);
    aux = ae_SLA_vad(i, ind);
    scatter_SLA = scatter(mean(aux), mean_sla_wr(i),sz, "red","filled");
end
hold off
legend([scatter_HC, scatter_SLA],"HC", "SLA");
ylabel("Word Error Rate");
xlabel("Articolation Entropy VAD with threshold");
title("Scatterplot for BBP files using VAD thresholded")
%%
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
legend([scatter_HC, scatter_SLA],"HC", "SLA");
ylabel("Word Error Rate");
xlabel("Confidence");
title("Scatterplot for BBP files using VOSK")
%%
figure;
hold on
for i=1:size(ae_HC,1)
    ind=find(ae_HC(i,:)~=0);
    aux = ae_HC(i, ind);
    scatter_HC = histogram(aux, 15);
end
figure;
hold on
for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    aux = ae_SLA(i, ind);
    scatter_SLA = histogram(aux, 15);
end
%%
aux = [];
for i=1:size(ae_HC,1)
    ind=find(ae_HC(i,:)~=0);
    aux = [aux ae_HC(i, ind)];
end
auxs =[];
for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    auxs = [auxs ae_SLA(i, ind)];
end
[h, p] = kstest2(aux, auxs);
disp(['h = ', num2str(h)]);
disp(['p-value = ', num2str(p)]);
%%
ar_HC=activation_ratio(path_HC, csv_HC_vad,csv_HC_vad_th,csv_HC);
ar_SLA=activation_ratio(path_SLA,csv_SLA_vad,csv_SLA_vad_th,csv_SLA);
%%
data = [mean(ar_HC,2), mean(ar_SLA,2)];
bar(data);
labels = {'VAD', 'VAD with threshold', 'Vosk'};

% Imposta le etichette dei gruppi di barre
set(gca, 'XTickLabel', labels);

xlabel('Segmentation methods');
ylabel('Mean activation ratio');
legend("HC", "SLA");
%%
af_HC=activation_frequency(path_HC, csv_HC_vad,csv_HC_vad_th,csv_HC);
af_SLA=activation_frequency(path_SLA,csv_SLA_vad,csv_SLA_vad_th,csv_SLA);
%%
data = [mean(af_HC,2), mean(af_SLA,2)];
bar(data);
labels = {'VAD', 'VAD with threshold', 'Vosk'};

% Imposta le etichette dei gruppi di barre
set(gca, 'XTickLabel', labels);

xlabel('Segmentation methods');
ylabel('Mean activation frequency');
legend("HC", "SLA");
%%
function m=compute_mean(ar)
    m=0;
    for i=1:size(ar,1)
        ind=find(ar(i,:)~=0);
        aux=ar(i,ind);
        ind=find(aux(:)~=-1);
        ax=aux(ind);
        m=m+mean(ax(:));
    end   
    m=m/size(ar,1);
end
%%
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