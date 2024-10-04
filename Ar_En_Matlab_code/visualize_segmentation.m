%% Visualize segmentation
% Function  to create a figure showing when the files are cutted over the
% original audio track.
%
%INPUT:
%           path: path to the folder containing the audio files
%
%           csv: csv file containig start and end time of audio segments
%           computed with VAD not thresholded
%
%           csv_th: csv file containig start and end time of audio segments
%           computed with VAD thresholded
%
%           varargin: csv file containig start and end time of audio segments
%           computed with vosk (optional parameter)

function visualize_segmentation(path, csv, csv_th, varargin)
    files = dir(fullfile(path, "*.wav"));
    sp = 2;
    if length(varargin)>=1
        sp = 3;
        csv_vosk=varargin{1};
    end
    for i=1:numel(files)
        filename=fullfile(path, files(i).name);
        [y, fs]=audioread(filename);
        
        ind=create_ind(files(i),csv, size(y,1));
        ind_th=create_ind(files(i), csv_th,size(y,1));
        th = 2*std(y);
        scale=max(abs(y));
        figure;
        subplot(sp,1,1);
        x=linspace(1,(numel(y)-1)/fs, numel(y));
        hold on
        plot(x,y,'b', x,ind*scale,'r', "LineWidth", 1.2);
        xlim([1, (numel(y)-1)/fs]);
        ylim([-(scale+0.1), scale+0.1]);
        line([1, (numel(y)-1)/fs], [th, th], 'Color', 'k', 'Linewidth', 0.7, 'LineStyle', '--');
        line([1, (numel(y)-1)/fs], [-th, -th], 'Color', 'k', 'Linewidth', 0.7, 'LineStyle', '--');
        hold off
        xlabel("Time(s)");
        title("VOD activation over sound ", files(i).name);
        
        subplot(sp,1,2);
        plot(x,y,'b', x,ind_th*scale,'r', "LineWidth", 1.2);
        xlim([1, (numel(y)-1)/fs]);
        ylim([-(scale+0.1), scale+0.1]);
        xlabel("Time(s)");
        title("VOD with threshold activation over sound ", files(i).name);
        
        if length(varargin)>=1
            ind_vosk = create_ind(files(i), csv_vosk, size(y,1));
            subplot(sp,1,3);
            plot(x,y,'b', x,ind_vosk*scale,'r');
            xlim([1, (numel(y)-1)/fs]);
            ylim([-(scale+0.1), scale+0.1]);
            xlabel("Time(s)");
            title("Vosk activation over sound ", files(i).name);
        end
    end
end
%%
function ind = create_ind(file, csv,s)
    ind=zeros(s,1);
    for j=1:height(csv)
        name=append(string(csv{j,1}), '.wav');
        if strcmp(name, file.name)
            ind(csv{j,2}:csv{j,3})=1;
        end
    end
end