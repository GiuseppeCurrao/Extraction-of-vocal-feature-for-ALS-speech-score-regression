function ae = ae_extraction(path,csv, varargin)
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

        if length(varargin)==2
            try
                F=melroot3_extraction(y,fs, varargin{1}, varargin{2});
            catch
                fprintf("Parameters impossible to extract\n");
            end

        end

        if length(varargin)==1
            try
                F=melroot3_extraction(y,fs, varargin{1});
            catch
                fprintf("Parameters impossible to extract\n");
            end
        end
        
        if length(varargin)==0
            try
                F=melroot3_extraction(y,fs);
            catch
                fprintf("Parameters impossible to extract\n");
            end
        end
        %F=mfcc(y,fs);

        if isempty(F)
            ae(row, col)=-1;
        else
            try
                ae(row,col)=[artic_ent(F,size(F,1))];
            catch
                fprintf("Articulation entropy not computed\n");
            end
        end
    end
end