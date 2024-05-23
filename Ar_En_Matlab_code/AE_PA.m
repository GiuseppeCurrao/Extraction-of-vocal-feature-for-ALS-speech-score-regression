clear all;
close all;
clc;
%%
% You may need to add voicebox (a Matlab toolbox) into your path
code_folder =pwd;
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
ae_HC = ae_extraction(path_HC, csv_HC);
ae_HC_th = ae_extraction(path_HC, csv_HC_th);

ae_SLA = ae_extraction(path_SLA, csv_SLA);
ae_SLA_th = ae_extraction(path_SLA, csv_SLA_th);
%%
[mean_hc, mp_hc]=compute_mean(ae_HC);
[mean_hc_th, mp_hc_th]=compute_mean(ae_HC_th);
%%
[mean_sla, mp_sla]=compute_mean(ae_SLA);
[mean_sla_th, mp_sla_th]=compute_mean(ae_SLA_th);
%%
for i=1:ar_HC
%%
function [varargout]=compute_mean(ar)
    m=0;
    mv=zeros(size(ar,1),1);
    for i=1:size(ar,1)
        ind=find(ar(i,:)~=0);
        aux=ar(i,ind);
        ind=find(aux(:)~=-1);
        ax=aux(ind);
        if ax
            m=m+mean(ax(:));
            mv(i)=mean(ax(:));
        end
    end   
    varargout{1}=m/size(ar,1);
    if nargout>1
        varargout{2}=mv;
    end
end