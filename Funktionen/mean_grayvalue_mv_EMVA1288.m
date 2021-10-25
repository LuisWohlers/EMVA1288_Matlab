function output = mean_grayvalue_mv_EMVA1288(input)
%nach EMVA 1288 Release 3.1 Formel (28), S.15, Ausgabe double
%für jeweils zwei Bilder pro Stufe
%input: MxNxL-Matrix (L MxN-Bilder), jeweils zwei Bilder pro Stufe,
%wobei die ersten beiden Bilder die dunklen Bilder sind und somit hier
%nicht benötigt werden
%für Aufnahmen wie im Beispieldatensatz von https://hci.iwr.uni-heidelberg.de/Simulated_Camera_Data_for_EMVA_1288_Verification
[M,N,L]=size(input);
images1=input(:,:,3:2:(L-1));
images2=input(:,:,4:2:L);
imgsum=images1+images2;
output=1/(2*N*M)*transpose(squeeze(sum(imgsum,[1,2])));
end

