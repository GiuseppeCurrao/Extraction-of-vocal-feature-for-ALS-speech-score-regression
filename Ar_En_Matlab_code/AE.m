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

path_Stroke = fullfile(code_folder, "Data\Stroke\Normal");
csv_Stroke = readtable("Stroke\Normal.csv");
csv_Stroke_vod = readtable("Stroke\Normal\table.csv");
csv_Stroke_vod_th = readtable("Stroke\Normal\table_th.csv");
%%
ae_HC=ae_extraction(path_HC, csv_HC);
ae_SLA=ae_extraction(path_SLA,csv_SLA);
ae_Stroke=ae_extraction(path_Stroke,csv_Stroke);
% %%
% ae_HC_vod=ae_extraction(path_HC, csv_HC_vod);
% ae_SLA_vod=ae_extraction(path_SLA, csv_SLA_vod);
% ae_Stroke_vod=ae_extraction(path_Stroke, csv_Stroke_vod);
% %%
% ae_HC_vod_th=ae_extraction(path_HC, csv_HC_vod_th);
% ae_SLA_vod_th=ae_extraction(path_SLA, csv_SLA_vod_th);
%ae_Stroke_vod_th=ae_extraction(path_Stroke, csv_Stroke_vod_th);
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
        try
            %F=melroot3_extraction(y,fs);
            F=mfcc(y,fs);
        catch
            fprintf("Parameters impossible to extract\n");
        end
        if isempty(F)
            ae(row, col)=0;
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
function mn = nozeromean(ae)
    for i=1:size(ae,1)
        aux=0;
        k=0;
        for j=1:size(ae,2)
            if ae(i,j)~=0
                aux=aux+ae(i,j);
                k=k+1;
            end
        end
        mn(i)=aux/k;
    end
    mn=mean(mn);
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