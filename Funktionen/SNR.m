function SNR = SNR(input,mean_dark)
%nach EMVA 1288 Release 3.1 Formel (10), S.6 
%input: MxNxL-Matrix (L MxN-Bilder), jeweils zwei Bilder pro Stufe,
%mean_dark: für Messvariante I (nur eine Belichtungszeit) ein Wert
%                   für Messvariante II ein Wert pro
%                   Belichtungsstufe 
[M,N,L]=size(input);
images1=input(:,:,1:2:(L-1));
images2=input(:,:,2:2:L);

diff=(double(images1)-double(images2)).^2;
vars=1/(2*N*M)*transpose(squeeze(sum(diff,[1,2])));

imgsum=images1+images2;
means=1/(2*N*M)*transpose(squeeze(sum(imgsum,[1,2])))-double(mean_dark);

SNR=means./sqrt(vars);

end

