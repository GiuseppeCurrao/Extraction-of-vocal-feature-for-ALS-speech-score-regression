clear all;
close all;
clc;
%%
% You may need to add voicebox (a Matlab toolbox) into your path
code_folder =pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
csv_HC = readtable("Healthy Control\Normal.csv");
csv_HC_vod = readtable("Healthy Control\Normal\Normal_csv.csv");
path_SLA = fullfile(code_folder, "Data\SLA\Normal");
csv_SLA = readtable("SLA\Normal.csv");
csv_SLA_vod = readtable("SLA\Normal\Normal_csv.csv");
path_Stroke = fullfile(code_folder, "Data\Stroke\Normal");
csv_Stroke = readtable("Stroke\Normal.csv");
csv_Stroke_vod = readtable("Stroke\Normal\Normal_csv.csv");
%%
ae_HC=ae_extraction(path_HC, csv_HC);
ae_SLA=ae_extraction(path_SLA,csv_SLA);
ae_Stroke=ae_extraction(path_Stroke,csv_Stroke);
%%
ae_HC_vod=ae_extraction(path_HC, csv_HC_vod);
ae_SLA_vod=ae_extraction(path_SLA, csv_SLA_vod);
ae_Stroke_vod=ae_extraction(path_Stroke, csv_Stroke_vod);
%%
mean_HC=nozeromean(ae_HC);
mean_SLA=nozeromean(ae_SLA);
mean_Stroke=nozeromean(ae_Stroke);
%%
for i=1:size(ae_HC,1)
    aux=0;
    k=0;
    for j=1:size(ae_HC,2)
        if ae_HC(i,j)~=0
            aux=aux+ae_HC(i,j);
            k=k+1;
        end
    end
    mn(i)=aux/k;
end
%%
mean(mn)
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
            F=melroot3_extraction(y,fs);
        catch
            fprintf("melroot3 impossible to extract\n");
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
