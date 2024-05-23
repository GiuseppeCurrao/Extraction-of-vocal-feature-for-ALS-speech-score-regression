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
    end
end