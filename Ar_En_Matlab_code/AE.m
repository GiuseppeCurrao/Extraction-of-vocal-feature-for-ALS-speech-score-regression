clear all;
close all;
clc;
%% Normal voice recording
%computation of the entropy with the three different segmentation method
code_folder =pwd;

path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
csv_HC = readtable("Healthy Control\Normal.csv");
csv_HC_vod = readtable("Healthy Control\Normal\table.csv");
csv_HC_vod_th = readtable("Healthy Control\Normal\table_th.csv");

path_SLA = fullfile(code_folder, "Data\SLA\Normal");
csv_SLA = readtable("SLA\Normal.csv");
csv_SLA_vod = readtable("SLA\Normal\table.csv");
csv_SLA_vod_th = readtable("SLA\Normal\table_th.csv");

%%
ae_HC=ae_extraction(path_HC, csv_HC);
ae_SLA=ae_extraction(path_SLA,csv_SLA);
%%
ae_HC_vod=ae_extraction(path_HC, csv_HC_vod);
ae_SLA_vod=ae_extraction(path_SLA, csv_SLA_vod);
%%
ae_HC_vod_th=ae_extraction(path_HC, csv_HC_vod_th);
ae_SLA_vod_th=ae_extraction(path_SLA, csv_SLA_vod_th);
%%
mea_HC=compute_mean(ae_HC);
mea_HC_vod=compute_mean(ae_HC_vod);
mea_HC_vod_th=compute_mean(ae_HC_vod_th);

mea_SLA=compute_mean(ae_SLA);
mea_SLA_vod=compute_mean(ae_SLA_vod);
mea_SLA_vod_th=compute_mean(ae_SLA_vod_th);
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
    aux = ae_HC(i, ind);
    yaux = csv_HC{(i-1)*count(i)+1:(i)*count(i),4};
    scatter(mean(aux), mean(yaux),sz,"blue", "filled");
    xlim([240 max(aux)]);
end
%%
for i=1:size(ae_SLA,1)
    ind=find(ae_SLA(i,:)~=0);
    aux = ae_SLA(i, ind);
    yaux = csv_SLA{(i-1)*countS(i)+1:(i)*countS(i),4};
    scatter(mean(aux), mean(yaux),sz, "red","filled");
    legend("HC", "SLA");
end
hold off
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
ar_HC=activation_ratio(path_HC, csv_HC_vod,csv_HC_vod_th,csv_HC);
ar_SLA=activation_ratio(path_SLA,csv_SLA_vod,csv_SLA_vod_th,csv_SLA);
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
[y,fs] = audioread('the path to your speech sample');
vad = vadsohn(y,fs);
y = y(vad==1);
y_nor = inten_norm(y,fs);
F = melroot3_extraction(y_nor,16000);
ae = artic_ent(F,200); % Set the second parameter based on the length of 
                       % your data or the minimum length of the data in
                       % your dataset.
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
function ae = ae_extraction(path,csv)
    str="";
    row=0;
    col=0;
    ae=[];
    for i = 1:size(csv,1)
        file_name=sprintf("%s.wav", string(csv{i,1}));
        if ~strcmp(str,file_name)
            row=row+1;
            str=file_name;
            col=1;
        else
            col=col+1;
        end
        file_path=fullfile(path, file_name);
        fstart=csv{i,2};
        fend=csv{i,3};
        [y,fs] = audioread(file_path);
        y=inten_norm(y(fstart:fend),fs);
        F = [];
        try
            F=melroot3_extraction(y,fs);
            %F=mfcc(y,fs);
        catch
            fprintf("Parameters impossible to extract\n");
        end
        if isempty(F)
            ae(row, col)=-1;
        else
            try
                ae(row,col)=[artic_ent(F,size(F,1))];
            catch
                fprintf("File non letto\n");
            end
        end
    end
end
%%
function ar = activation_ratio(path,csv, csv_th, varargin)
    files = dir(fullfile(path, "*.wav"));

    for i=1:numel(files)
        filename=fullfile(path, files(i).name);
        [y, fs]=audioread(filename);
        
        ind=zeros(size(y));
        for j=1:height(csv)
            name=append(string(csv{j,1}), '.wav');
            if strcmp(name, files(i).name)
                ind(csv{j,2}:csv{j,3})=1;
            end
        end

        ind_th=zeros(size(y));
        for j=1:height(csv_th)
            name=append(string(csv_th{j,1}), '.wav');
            if strcmp(name, files(i).name)
                ind_th(csv_th{j,2}:csv_th{j,3})=1;
            end
        end

        count=sum(ind);
        ar(1,i)=count/size(ind,1);

        count=sum(ind_th);
        ar(2,i)=count/size(ind_th,1);
        
        if length(varargin)>=1
            ind_vosk=zeros(size(y));
            csv=varargin{1};
            for j=1:height(csv)
                name=append(string(csv{j,1}), '.wav');
                if strcmp(name, files(i).name)
                    ind_vosk(csv{j,2}:csv{j,3})=1;
                end
            end
        count=sum(ind_vosk);
        ar(3,i)=count/size(ind_vosk,1);
        end
        count=sum(ind);
        ar(3,i)=count/size(ind,1);
    end
end