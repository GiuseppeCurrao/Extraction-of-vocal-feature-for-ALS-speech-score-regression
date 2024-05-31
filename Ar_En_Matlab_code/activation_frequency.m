function af = activation_frequency(path, csv, csv_th, varargin)
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

        ind=ind(:)';
        ind = [0, ind, 0];
        aux=diff(ind);
        af(1,i)=sum(aux==1);
        
        ind_th=ind_th(:)';
        ind_th = [0 ind_th 0];
        au = diff(ind_th);
        af(2,i)=sum(au==1);
        
        if length(varargin)>=1
            ind_vosk=zeros(size(y));
            csv_vosk=varargin{1};
            for j=1:height(csv_vosk)
                name=append(string(csv_vosk{j,1}), '.wav');
                if strcmp(name, files(i).name)
                    ind_vosk(csv_vosk{j,2}:csv_vosk{j,3})=1;
                end
            end
            ind_vosk=ind_vosk(:)';
            ind_vosk = [0 ind_vosk 0];
            aux=diff(ind_vosk);
            af(3,i)=sum(aux==1);
        end
    end
end