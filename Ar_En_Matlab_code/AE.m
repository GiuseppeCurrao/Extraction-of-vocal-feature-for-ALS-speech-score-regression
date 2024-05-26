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
%%
ae_HC=ae_extraction(path_HC, csv_HC);
ae_SLA=ae_extraction(path_SLA,csv_SLA);
%%
ae_HC_vad=ae_extraction(path_HC, csv_HC_vad);
ae_SLA_vad=ae_extraction(path_SLA, csv_SLA_vad);
%%
ae_HC_vad_th=ae_extraction(path_HC, csv_HC_vad_th);
ae_SLA_vad_th=ae_extraction(path_SLA, csv_SLA_vad_th);
%%
mea_HC=compute_mean(ae_HC);
mea_HC_vad=compute_mean(ae_HC_vad);
mea_HC_vad_th=compute_mean(ae_HC_vad_th);

mea_SLA=compute_mean(ae_SLA);
mea_SLA_vad=compute_mean(ae_SLA_vad);
mea_SLA_vad_th=compute_mean(ae_SLA_vad_th);
%%
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
%%
figure;
sz=80;
hold on
for i=1:size(ae_HC,1)
    ind=find(ae_HC(i,:)~=0);
    aux = ae_HC_vad(i, ind);
    yaux = csv_HC{(i-1)*count(i)+1:(i)*count(i),4};
    scatter(mean(aux), mean(yaux),sz,"blue", "filled");
    xlim([min(aux) max(aux)]);
end
%%
for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    aux = ae_SLA(i, ind);
    yaux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),4};
    scatter(mean(aux), mean(yaux),sz, "red","filled");
end
hold off
legend("SLA");
ylabel("Word Error Rate");
xlabel("Articolation Entropy");
%%
figure;
hold on
for i=1:size(ae_HC,1)
    aux = csv_HC{(i-1)*count(i)+1:(i)*count(i),4};
    yaux = csv_HC{(i-1)*count(i)+1:(i)*count(i),5};
    % h=scatter(aux, yaux,sz, "filled");
    % color = get(h, 'CData');
    scatter(mean(aux), mean(yaux),sz, "filled", "red");
end

for i=1:size(ae_SLA,1)
    aux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),4};
    yaux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),5};
    % h=scatter(aux, yaux,sz, "diamond", "filled");
    % color = get(h, 'CData');
    scatter(mean(aux), mean(yaux),sz,"blue", "diamond", "filled");
end
legend("HC", "SLA");
ylabel("Word Error Rate");
xlabel("Confidence");
%%
data=[mean(csv_HC{:,5}), mean(csv_SLA{:,5})];
bar(data);
%%
mean_HC=nozeromean(ae_HC);
mean_SLA=nozeromean(ae_SLA);
mean_Stroke=nozeromean(ae_Stroke);
%%
ar_HC=activation_ratio(path_HC, csv_HC_vad,csv_HC_vad_th,csv_HC);
ar_SLA=activation_ratio(path_SLA,csv_SLA_vad,csv_SLA_vad_th,csv_SLA);
ar_Stroke=activation_ratio(path_Stroke, csv_Stroke_vod,csv_Stroke_vod_th, csv_Stroke);
%%
data = [mean(ar_HC,2), mean(ar_SLA,2), mean(ar_Stroke,2)];
bar(data);
labels = {'VOD', 'VOD with threshold', 'Vosk'};

% Imposta le etichette dei gruppi di barre
set(gca, 'XTickLabel', labels);

xlabel('Segmentation methods');
ylabel('Mean activation ratio');
legend("HC", "SLA", "Stroke");
%%
figure;
plot(ae);
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