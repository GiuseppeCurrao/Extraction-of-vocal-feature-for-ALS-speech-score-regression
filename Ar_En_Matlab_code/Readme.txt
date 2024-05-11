This folder contains the Matlab codes for calculating articulation entropy proposed in the following paper:

	"Y. Jiao, V. Berisha, J. M. Liss, S. C. Hsu, E. Levy, M. McAuliffe, Articulation entropy: an unsupervised estimation of articulatory precision. IEEE Signal Processing Letter. 2016"
	
It contains:

(a) A script (test_script.m) for users to start from;
(b) The function for intensity normalization. (inten_norm.m);
(c) The function for extracting MelRoot3 features stacked with 160ms window (melroot3_extraction.m);
(d) The function for calculating articulation entropy using the above features based on minimium spanning tree (artic_ent.m).

You may need to add voicebox (a Matlab toolbox) into your path. You can download voicebox from http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html

Note that if your speech samples are not enough for each speaker, you'd better use the same reading materials for all speakers.

 

 


	