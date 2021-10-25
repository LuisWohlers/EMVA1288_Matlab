 function [means,vars] = mean_and_temporalvariance(input,mean_dark,var_dark)
%nach EMVA 1288 Release 3.1 Formeln (28) und (29), S.16, Ausgabe double
%input: MxNxL-Matrix (L MxN-Bilder), jeweils zwei Bilder pro Stufe
%mean_dark,var_dark: für Messvariante I (nur eine Belichtungszeit) je ein Wert
%                   für Messvariante II je ein Wert pro
%                   Belichtungsstufe 
[M,N,L]=size(input);
images1=input(:,:,1:2:(L-1));
images2=input(:,:,2:2:L);

diff=(double(images1)-double(images2)).^2;
vars=1/(2*N*M)*transpose(squeeze(sum(diff,[1,2])))-double(var_dark);

imgsum=images1+images2;
means=1/(2*N*M)*transpose(squeeze(sum(imgsum,[1,2])))-double(mean_dark);
end

