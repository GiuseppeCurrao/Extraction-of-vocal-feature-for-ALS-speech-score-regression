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
% ae_HC=ae_extraction(path_HC, csv_HC);
% ae_SLA=ae_extraction(path_SLA,csv_SLA);
% ae_Stroke=ae_extraction(path_Stroke,csv_Stroke);
% %%
% ae_HC_vod=ae_extraction(path_HC, csv_HC_vod);
% ae_SLA_vod=ae_extraction(path_SLA, csv_SLA_vod);
% ae_Stroke_vod=ae_extraction(path_Stroke, csv_Stroke_vod);
% %%
% mean_HC=nozeromean(ae_HC);
% mean_SLA=nozeromean(ae_SLA);
% mean_Stroke=nozeromean(ae_Stroke);
%%
ar_HC=activation_ratio(path_HC, csv_HC);
%%
ar_SLA=activation_ratio(path_SLA,csv_SLA);
%%
ar_Stroke=activation_ratio(path_Stroke, csv_Stroke);
%%
mean(ar_HC,2)
mean(ar_SLA,2)
mean(ar_Stroke,2)
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
%%
function ar = activation_ratio(path,csv)
    files = dir(fullfile(path, "*.wav"));
    for i=1:numel(files)
        filename=fullfile(path, files(i).name);
        [y, fs]=audioread(filename);
        y=int
        vad=vadsohn(y,fs);
        
        aux=zeros(size(y));
        threshold=std(y);
        for j=1:size(y,1)
            if y(j)>=threshold
                aux(j)=1;
            end
        end
        vad_th=vadsohn(y.*aux,fs);

        ind=zeros(size(y));
        for j=1:height(csv)
            name=append(string(csv{j,1}), '.wav');
            if strcmp(name, files(i).name)
                ind(csv{j,2}:csv{j,3})=1;
            end
        end

        scale=max(abs(y));
        figure;
        
        x=linspace(1,numel(y), numel(y));
        subplot(3,1,1);
        plot(x,y, 'b', x, vad*scale, 'r');
        xlim([1, numel(y)]);
        ylim([-(scale+0.1), scale+0.1]);
        xlabel("Frames");
        title("VOD activation over sound");
        subplot(3,1,2);
        plot(x,y, 'b', x, vad_th*scale, 'r');
        xlim([1, numel(y)]);
        ylim([-(scale+0.1), scale+0.1]);
        xlabel("Frames");
        title("VOD with threshold activation over sound");
        subplot(3,1,3);
        plot(x,y,'b', x,ind*scale,'r');
        xlim([1, numel(y)]);
        ylim([-(scale+0.1), scale+0.1]);
        xlabel("Frames");
        title("Vosk activation over sound");

        count=sum(vad);
        ar(1,i)=count/size(vad,1);

        count=sum(vad_th);
        ar(2,i)=count/size(vad_th,1);

        count=sum(ind);
        ar(3,i)=count/size(ind,1);
    end
end