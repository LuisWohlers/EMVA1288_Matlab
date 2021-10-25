function output = temporalvariance_grayvalue_mv_EMVA1288(input)
%nach EMVA 1288 Release 3.1 Formel (29), S.16, Ausgabe double
%input: MxNxL-Matrix (L MxN-Bilder), jeweils zwei Bilder pro Stufe,
%wobei die ersten beiden Bilder die dunklen Bilder sind und somit hier
%nicht benötigt werden
%für Aufnahmen wie im Beispieldatensatz von https://hci.iwr.uni-heidelberg.de/Simulated_Camera_Data_for_EMVA_1288_Verification
[M,N,L]=size(input);
images1=input(:,:,3:2:(L-1));
images2=input(:,:,4:2:L);

diff=(double(images1)-double(images2)).^2;
output=1/(2*N*M)*transpose(squeeze(sum(diff,[1,2])));
end

