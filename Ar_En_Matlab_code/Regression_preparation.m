close all
clear all
clc
%% Creation of the csv used for the regression

code_folder=pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\Normal");
path_SLA_ptk = fullfile(code_folder, "Data\SLA\Normal");

% csv containing the scores of the patients
csv_params_hc = readtable(fullfile(code_folder, "Data\Healthy Control\params.csv"));
csv_params_sla = readtable(fullfile(code_folder,"Data\SLA\params.csv"));

% csv containing the time-frames of voice activation

csv_hc_vosk = readtable(fullfile(code_folder, "Data\Healthy Control\Normal.csv"));
% csv_hc_vad = readtable(fullfile(code_folder, "Data\Healthy Control\Normal\table.csv"));
% csv_hc_vad_th = readtable(fullfile(code_folder, "Data\Healthy Control\Normal\table_th.csv"));

csv_sla_vosk = readtable(fullfile(code_folder, "Data\SLA\Normal.csv"));
% csv_sla_vad = readtable(fullfile(code_folder, "Data\SLA\Normal\table.csv"));
% csv_sla_vad_th = readtable(fullfile(code_folder, "Data\SLA\Normal\table_th.csv"));

%% Extrapolation of parameters for the BBP files
% Articulation Entropy
ae_hc = ae_extraction(path_HC, csv_hc_vosk, 10,5);
ae_sla = ae_extraction(path_SLA_ptk, csv_sla_vosk, 10, 5);
% WER and confindence values are listed in the csv file already
%% Retriving and saving all the values
[count_hc, count_sla] = count_csv(csv_hc_vosk, csv_sla_vosk);
ae = {};
conf = {};
wer = {};
slp_bbp = {};
ID = {};
label = {};

sum=1;
for i=1:size(count_hc,2)
    aux = ae_hc(i, find(ae_hc(i, :)~=0));
    ae{end+1}=aux;
    file_name = csv_hc_vosk{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 0;
    conf{end+1}=(csv_hc_vosk{sum:sum+count_hc(i)-1,4})';
    wer{end+1}=(csv_hc_vosk{sum:sum+count_hc(i)-1,5})';


    aux = strcmpi(csv_params_hc{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_hc{ind, 8}+csv_params_hc{ind, 15})/2;
    slp_bbp{end+1} = mean_slp;
    sum = sum+count_hc(i);
end


sum=1;
for i=1:size(count_sla,2)
    aux = ae_sla(i, find(ae_sla(i, :)~=0));
    ae{end+1}=aux;

    file_name = csv_sla_vosk{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 1;
    conf{end+1}=(csv_sla_vosk{sum:sum+count_sla(i)-1,4})';
    wer{end+1}=(csv_sla_vosk{sum:sum+count_sla(i)-1,5})';

    if contains(file_name, "_al")
        file_name=strrep(file_name, "_al", "");
    end
    aux = strcmpi(csv_params_sla{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_sla{ind, 8}+csv_params_sla{ind, 15})/2;
    slp_bbp{end+1} = mean_slp;
    sum = sum+count_sla(i);
end
save(fullfile(code_folder, "Data/bbp_regr.mat"), "ID","label", "ae","conf","wer","slp_bbp");
%% Preparation of the mat file for the PA files
clear all
clc

code_folder=pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\PA");
path_SLA_ptk = fullfile(code_folder, "Data\SLA\PA");

csv_params_hc = readtable(fullfile(code_folder, "Data\Healthy Control\params.csv"));
csv_params_sla = readtable(fullfile(code_folder,"Data\SLA\params.csv"));

csv_hc = readtable(fullfile(code_folder,"Data\Healthy Control\PA\table.csv"));
csv_hc_th = readtable(fullfile(code_folder,"Data\Healthy Control\PA\table_th.csv"));

csv_sla = readtable(fullfile(code_folder, "Data\SLA\PA\table.csv"));
csv_sla_th = readtable(fullfile(code_folder, "Data\SLA\PA\table_th.csv"));
%% Activation Ratio extraction
ar_hc=activation_ratio(path_HC, csv_hc, csv_hc_th);
ar_sla=activation_ratio(path_SLA_ptk, csv_sla,csv_sla_th);
[ar_pa, ar_th_pa] = tocell(ar_hc, ar_sla);
%% Activation Frequency extraction
af_hc=activation_frequency(path_HC,csv_hc, csv_hc_th);
af_sla=activation_frequency(path_SLA_ptk,csv_sla, csv_sla_th);
[af_pa, af_th_pa] = tocell(af_hc, af_sla);
%% Articulation Entropy extraction, not used
% ae_hc = ae_extraction(path_HC, csv_hc,10,5);
% ae_sla = ae_extraction(path_SLA, csv_sla,10,5);
% ae = removeMV(ae_hc, ae_sla);
% 
% ae_hc_th = ae_extraction(path_HC, csv_hc_th,10,5);
% ae_sla_th = ae_extraction(path_SLA, csv_sla_th,10,5);
% ae_th = removeMV(ae_hc_th, ae_sla_th);
%% Compute the mean of the SLP values and saving of the data
[count_hc, count_sla] = count_csv(csv_hc, csv_sla);
slp_pa = {};
ID = {};
label = {};

sum=1;
for i=1:size(count_hc,2)
    file_name= csv_hc{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 0;
    if contains(file_name, "_al")
        file_name=strrep(file_name, "_al", "");
    end
    aux = strcmpi(csv_params_hc{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_hc{ind, 8}+csv_params_hc{ind, 15})/2;
    slp_pa{end+1} = mean_slp;
    sum = sum + count_hc(i);
end

sum=1;
for i=1:size(count_sla,2)
    file_name= csv_sla{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 1;
    if contains(file_name, "_al")
        file_name=strrep(file_name, "_al", "");
    end
    aux = strcmpi(csv_params_sla{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_sla{ind, 8}+csv_params_sla{ind, 15})/2;
    slp_pa{end+1} = mean_slp;
    sum= sum+count_sla(i);
end

save(fullfile(code_folder, "Data/pa_regr.mat"),"ID","label","ar_pa","af_pa","slp_pa");
%%
[count_hc, count_sla] = count_csv(csv_hc_th, csv_sla_th);
slp_th_pa = {};
ID = {};
label = {};
sum = 1;
for i=1:size(count_hc,2)
    
    file_name= csv_hc_th{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 0;

    if contains(file_name, "_al")
        file_name=strrep(file_name, "_al", "");
    end
    aux = strcmp(csv_params_hc{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_hc{ind, 8}+csv_params_hc{ind, 15})/2;
    slp_th_pa{end+1} = mean_slp;
    sum = sum+count_hc(i);
end

sum=1;
for i=1:size(count_sla,2)
  
    file_name= csv_sla_th{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 1;

    if contains(file_name, "_al")
        file_name=strrep(file_name, "_al", "");
    end
    aux = strcmp(csv_params_sla{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_sla{ind, 8}+csv_params_sla{ind, 15})/2;
    slp_th_pa{end+1} = mean_slp;
    sum=sum+count_sla(i);
end

save(fullfile(code_folder, "Data/pa_th_regr.mat"),"ID","label","ar_th_pa","af_th_pa","slp_th_pa");
%% Preparation of PATAKA files
clear all
clc

code_folder=pwd;
path_HC = fullfile(code_folder, "Data\Healthy Control\PATAKA");
path_SLA = fullfile(code_folder, "Data\SLA\PATAKA");

csv_params_hc = readtable(fullfile(code_folder, "Data\Healthy Control\params.csv"));
csv_params_sla = readtable(fullfile(code_folder,"Data\SLA\params.csv"));

csv_hc = readtable(fullfile(code_folder,"Data\Healthy Control\PATAKA\table.csv"));
csv_hc_th = readtable(fullfile(code_folder,"Data\Healthy Control\PATAKA\table_th.csv"));

csv_sla = readtable(fullfile(code_folder, "Data\SLA\PATAKA\table.csv"));
csv_sla_th = readtable(fullfile(code_folder, "Data\SLA\PATAKA\table_th.csv"));
%% Activation Ratio extraction
ar_hc=activation_ratio(path_HC, csv_hc, csv_hc_th);
ar_sla=activation_ratio(path_SLA, csv_sla,csv_sla_th);
[ar_ptk, ar_th_ptk] = tocell(ar_hc, ar_sla);
%% Activation Frequency extraction
af_hc=activation_frequency(path_HC,csv_hc, csv_hc_th);
af_sla=activation_frequency(path_SLA,csv_sla, csv_sla_th);
[af_ptk, af_th_ptk] = tocell(af_hc, af_sla);
%% Articulation Entropy extraction, not used
% ae_hc = ae_extraction(path_HC, csv_hc,10,5);
% ae_sla = ae_extraction(path_SLA, csv_sla,10,5);
% ae = removeMV(ae_hc, ae_sla);
% 
% ae_hc_th = ae_extraction(path_HC, csv_hc_th,10,5);
% ae_sla_th = ae_extraction(path_SLA, csv_sla_th,10,5);
% ae_th = removeMV(ae_hc_th, ae_sla_th);
%% Compute the mean of the SLP values and saving all the data
[count_hc, count_sla] = count_csv(csv_hc, csv_sla);
slp_ptk = {};
ID = {};
label = {};
sum=1;
for i=1:size(count_hc,2)
    file_name= csv_hc{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 0;

    if contains(file_name, "l")
        file_name=strrep(file_name, "l", "");
    end
    aux = strcmpi(csv_params_hc{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_hc{ind, 8}+csv_params_hc{ind, 15})/2;
    slp_ptk{end+1} = mean_slp;
    sum = sum + count_hc(i);
end

sum=1;
for i=1:size(count_sla,2)
    file_name= csv_sla{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 1;

    if contains(file_name, "l")
        file_name=strrep(file_name, "l", "");
    end
    aux = strcmpi(csv_params_sla{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_sla{ind, 8}+csv_params_sla{ind, 15})/2;
    slp_ptk{end+1} = mean_slp;
    sum= sum+count_sla(i);
end

save(fullfile(code_folder, "Data/pataka_regr.mat"),"ID", "label","ar_ptk","af_ptk","slp_ptk");
%%
[count_hc, count_sla] = count_csv(csv_hc_th, csv_sla_th);
slp_th_ptk = {};
ID = {};
label = {};
sum = 1;
for i=1:size(count_hc,2)
    
    file_name= csv_hc_th{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 0;
    if contains(file_name, "l")
        file_name=strrep(file_name, "l", "");
    end
    aux = strcmpi(csv_params_hc{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_hc{ind, 8}+csv_params_hc{ind, 15})/2;
    slp_th_ptk{end+1} = mean_slp;
    sum = sum+count_hc(i);
end

sum=1;
for i=1:size(count_sla,2)
  
    file_name= csv_sla_th{sum,1};
    ID{end+1} = file_name{1,1}(1:4);
    label{end+1} = 1;
    if contains(file_name, "l")
        file_name=strrep(file_name, "l", "");
    end
    aux = strcmpi(csv_params_sla{:,1}, file_name);
    ind = find(aux);
    mean_slp = (csv_params_sla{ind, 8}+csv_params_sla{ind, 15})/2;
    slp_th_ptk{end+1} = mean_slp;
    sum=sum+count_sla(i);
end

save(fullfile(code_folder, "Data/pataka_th_regr.mat"),"ID","label","ar_th_ptk","af_th_ptk","slp_th_ptk");
%% Dataset preparation for both syllables
% Since both PA and PATAKA files are taken from the same patients, it is
% possible to combine them
clear all
clc
code_folder = pwd;
bbp = load("Data\bbp_regr.mat");
pa = load("Data\pa_regr.mat");
ptk = load("Data\pataka_regr.mat");

pa_th = load("Data\pa_th_regr.mat");
ptk_th = load("Data\pataka_th_regr.mat");
%%
bbp_id=bbp.ID;
pa_id=pa.ID;
ptk_id=ptk.ID;
%%
ae = {};
wer = {};
conf = {};
ar_pa = {};
ar_th_pa = {};
ar_ptk = {};
ar_th_ptk = {};
af_pa = {};
af_th_pa = {};
af_ptk = {};
af_th_ptk = {};
slp = {};
ID = {};
label = {};

for i=1:size(bbp_id,2)
    j = find(strcmp(pa_id, bbp_id{i}));
    k = find(strcmp(ptk_id, bbp_id{i}));
    if j*k~=0
        ae{end+1} = bbp.ae{i};
        wer{end+1} = bbp.wer{i};
        conf{end+1} = bbp.conf{i};

        ar_pa{end+1} = pa.ar_pa{j};
        ar_th_pa{end+1} = pa_th.ar_th_pa{j};
        ar_ptk{end+1} = ptk.ar_ptk{k};
        ar_th_ptk{end+1} = ptk_th.ar_th_ptk{k};

        af_pa{end+1} = pa.af_pa{j};
        af_th_pa{end+1} = pa_th.af_th_pa{j};
        af_ptk{end+1} = ptk.af_ptk{k};
        af_th_ptk{end+1} = ptk_th.af_th_ptk{k};

        ID{end+1} = bbp_id{i};
        label{end+1} = bbp.label{i};
        slp{end+1} = (bbp.slp_bbp{i}+pa.slp_pa{j}+ptk.slp_ptk{k})/3;
    end
end

save(fullfile(code_folder, "Data/complete_regr.mat"),"ID","label", ...
    "ae","wer","conf", ...
    "ar_pa","ar_ptk","af_pa","af_ptk", "slp");

save(fullfile(code_folder, "Data/complete_th_regr.mat"),"ID","label", ...
    "ae","wer","conf", ...
    "ar_th_pa","ar_th_ptk","af_th_pa","af_th_ptk", "slp");
%% Syllables
ar_pa = {};
ar_th_pa = {};
ar_ptk = {};
ar_th_ptk = {};
af_pa = {};
af_th_pa = {};
af_ptk = {};
af_th_ptk = {};
slp = {};
ID = {};
label = {};

for k=1:size(ptk_id,2)
    j = find(strcmp(pa_id, ptk_id{k}));
    if j~=0
        ar_pa{end+1} = pa.ar_pa{j};
        ar_th_pa{end+1} = pa_th.ar_th_pa{j};
        ar_ptk{end+1} = ptk.ar_ptk{k};
        ar_th_ptk{end+1} = ptk_th.ar_th_ptk{k};

        af_pa{end+1} = pa.af_pa{j};
        af_th_pa{end+1} = pa_th.af_th_pa{j};
        af_ptk{end+1} = ptk.af_ptk{k};
        af_th_ptk{end+1} = ptk_th.af_th_ptk{k};

        ID{end+1} = ptk_id{k};
        label{end+1} = ptk.label{k};
        slp{end+1} = (pa.slp_pa{j}+ptk.slp_ptk{k})/2;        
    end
end

save(fullfile(code_folder, "Data/syllables_regr.mat"),"ID","label", ...
    "ar_pa","ar_ptk","af_pa","af_ptk", "slp");
save(fullfile(code_folder, "Data/syllables_th_regr.mat"),"ID","label", ...
    "ar_th_pa","ar_th_ptk","af_th_pa","af_th_ptk", "slp");
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

%%
function [ae] = removeMV(ae_hc, ae_sla)
    ae = {};
    for i=1:size(ae_hc,1)
        ind = find(ae_hc(i,:)~=0);
        aux = ae_hc(ind);
        ind = find(aux(:)~=-1);
        ae{end+1} = aux(ind);
    end

    for i=1:size(ae_sla,1)
        ind = find(ae_sla(i,:)~=0);
        aux = ae_sla(ind);
        ind = find(aux(:)~=-1);
        ae{end+1} = aux(ind);
    end
end
%%
function [ a, a_th ] = tocell( a_hc, a_sla )
    a = {};
    a_th = {};
    for i = 1:size(a_hc,2)
        a{end+1} = a_hc(1,i);
        a_th{end+1} = a_hc(2,i);
    end
    
    for i = 1:size(a_sla, 2)
        a{end+1} = a_sla(1,i);
        a_th{end+1} = a_sla(2,i);
    end
end
