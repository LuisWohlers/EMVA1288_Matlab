function SNR = SNR_mv_EMVA1288(input,mean_dark)
%nach EMVA 1288 Release 3.1 Formel (10), S.6 
%input: MxNxL-Matrix (L MxN-Bilder), jeweils zwei Bilder pro Stufe,
%wobei die ersten beiden Bilder die dunklen Bilder sind 
%für Aufnahmen wie im Beispieldatensatz von https://hci.iwr.uni-heidelberg.de/Simulated_Camera_Data_for_EMVA_1288_Verification
[M,N,L]=size(input);
images1=input(:,:,3:2:(L-1));
images2=input(:,:,4:2:L);

diff=(double(images1)-double(images2)).^2;
vars=1/(2*N*M)*transpose(squeeze(sum(diff,[1,2])));

imgsum=images1+images2;
means=1/(2*N*M)*transpose(squeeze(sum(imgsum,[1,2])))-mean_dark;

SNR=means./sqrt(vars);

end

