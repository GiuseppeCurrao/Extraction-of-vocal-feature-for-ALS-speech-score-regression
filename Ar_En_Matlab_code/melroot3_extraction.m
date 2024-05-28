function [ stack_F ] = melroot3_extraction( y,fs,varargin )
%Extract MelRoot3 features and stack with a 160ms window
%Input:     y:  speech signal
%           fs: sampling rate (Hz)
%Output:    F:  MelRoot3 features, colums correspond to the dimension of
%               features

if length(varargin)==2
    win=varargin{1}*16;
    ov=varargin{2}*16;
elseif varargin==1
    win= varargin{1}*16;
    ov=160;
else
    win=320;
    ov=160;
end

if size(y,2)~=1
    y = y(:,1);
end
if fs~=16000
    [y,fs] = resample(y,16000,fs); % If sampling rate is not 16kHz, resample it to 16kHz.
    fs = 16000;
end


F1=melbank_r3(y,fs,'a',12,win,ov); % Extract MelRoot3 from each frame of speech. frame length is 20ms with 10ms overlap. 
stack_F = [];
for i = 1:12:size(F1,2)-11
    mtx = F1(:,i:i+11);
    vec = reshape(mtx,1,12*12);
    stack_F = [stack_F;vec];
end

end

