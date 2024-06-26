function y=melbank_r3(s,fs,w,p,n,inc,fl,fh)
%MELCEPST Calculate the mel cepstrum of a signal C=(S,FS,W,NC,P,N,INC,FL,FH)
%
%
% Simple use: (1) c=melcepst(s,fs)          % calculate mel cepstrum with 12 coefs, 256 sample frames
%			  (2) c=melcepst(s,fs,'e0dD')   % include log energy, 0th cepstral coef, delta and delta-delta coefs
%
% Inputs:
%     s	  speech signal
%     fs  sample rate in Hz (default 11025)
%     w   mode string (see below)
%     nc  number of cepstral coefficients excluding 0'th coefficient [default 12]
%     p   number of filters in filterbank [default: floor(3*log(fs)) =  approx 2.1 per ocatave]
%     n   length of frame in samples [default power of 2 < (0.03*fs)]
%     inc frame increment [default n/2]
%     fl  low end of the lowest filter as a fraction of fs [default = 0]
%     fh  high end of highest filter as a fraction of fs [default = 0.5]
%
%		w   any sensible combination of the following:
%
%               'R'  rectangular window in time domain
%				'N'	 Hanning window in time domain
%				'M'	 Hamming window in time domain (default)
%
%               't'  triangular shaped filters in mel domain (default)
%               'n'  hanning shaped filters in mel domain
%               'm'  hamming shaped filters in mel domain
%
%				'p'	 filters act in the power domain
%				'a'	 filters act in the absolute magnitude domain (default)
%
%               '0'  include 0'th order cepstral coefficient
%				'E'  include log energy
%				'd'	 include delta coefficients (dc/dt)
%				'D'	 include delta-delta coefficients (d^2c/dt^2)
%
%               'z'  highest and lowest filters taper down to zero (default)
%               'y'  lowest filter remains at 1 down to 0 frequency and
%			   	     highest filter remains at 1 up to nyquist freqency
%
%		       If 'ty' or 'ny' is specified, the total power in the fft is preserved.
%
% Outputs:	c     mel cepstrum output: one frame per row. Log energy, if requested, is the
%                 first element of each row followed by the delta and then the delta-delta
%                 coefficients.
%

% BUGS: (1) should have power limit as 1e-16 rather than 1e-6 (or possibly a better way of choosing this)
%           and put into VOICEBOX
%       (2) get rdct to change the data length (properly) instead of doing it explicitly (wrongly)

%      Copyright (C) Mike Brookes 1997
%      Version: $Id: melcepst.m 3497 2013-09-26 16:10:51Z dmb $
%
%   VOICEBOX is a MATLAB toolbox for speech processing.
%   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   http://www.gnu.org/copyleft/gpl.html or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2 fs=11025; end
if nargin<3 w='M'; end
if nargin<4 nc=12; end
if nargin<5 p=floor(3*log(fs)); end
if nargin<6 n=pow2(floor(log2(0.03*fs))); end
if nargin<9
   fh=0.5;   
   if nargin<8
     fl=0;
     if nargin<7
        inc=floor(n/2);
     end
  end
end

if isempty(w)
   w='M';
end
if any(w=='R')
   z=enframe(s,n,inc);
elseif any (w=='N')
   z=enframe(s,hanning(n),inc);
else
   z=enframe(s,hamming(n),inc);
end
f=rfft(z.');
[m,a,b]=melbankm(p,n,fs,fl,fh,w);
pw=f(a:b,:).*conj(f(a:b,:));
pth=max(pw(:))*1E-20;
if any(w=='p')
   y=(max(m*pw,pth));
else
   ath=sqrt(pth);
   y=(max(m*abs(f(a:b,:)),ath)).^(1/3);
end
end

