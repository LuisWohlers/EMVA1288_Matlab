function [mean_dark,var_dark,var_dark_0] = dark_mean_var(input,arg2)
%nach EMVA 1288 Release 3.1 
%input: MxNx2L-Matrix (input) aus 2L Bildern bei L
%verschiedenen Belichtungszeiten, jeweils zwei Bilder pro Belichtungszeit,
%bei Variante I also nur zwei Aufnahmen bei der Belichtungszeit, bei welcher auch
%die Bilder mit ansteigender Photonenanzahl aufgenommen wurden
%
%arg2: Bei Variante II eine MxNx2-Matrix (zwei Dunkelbilder bei minimaler
%Belichtungszeit), bei Variante I der Abstand der Belichtungszeiten in s
%(dieser muss entsprechend EMVA 1288 immer gleich sein)
%
%Ausgabe bei Variante II: ein Mittelwert, eine Varianz, Mittelwert der zwei
%zusätzlichen Aufnahmen bei minimler Belichtungszeit als var_dark 0
%zusätzlichen Dunkelbilder
%Bei Variante I: Mittelwert und Varianz pro Belichtungsstufe (zwei
%Vektoren), var_dark_0 ist offset (y=slope*x+offset) der linearen
%Regression bzgl. der Varianzen über die Belichungszeiten (vgl. S.17,
%"temporal dark noise" - "For measurement method I with variable exposure time in Section 6.3 the temporal
%dark noise is found as the offset of the linear correspondence of the 
%sigma^2_y.dark over the exposure times"
%
%var_dark_0 dient zur Berechnung des temporal dark noise nach Formel (31)


[M,N,L]=size(input);
images1=input(:,:,1:2:(L-1)); %jeweils erste Bilder
images2=input(:,:,2:2:L); %jeweils zweite Bilder

%Mittelwerte ausrechnen
imgsum=double(images1)+double(images2);
mean_dark=1/(2*N*M)*transpose(squeeze(sum(imgsum,[1,2])));

%Varianzen ausrechnen
diff=(double(images1)-double(images2)).^2;
var_dark=1/(2*N*M)*transpose(squeeze(sum(diff,[1,2])));

if(L==2) %Variante II
    image1=arg2(:,:,1);
    image2=arg2(:,:,2);
    
    diff2=(double(image1)-double(image2)).^2;
    var_dark_0 = 1/(2*N*M)*sum(diff2(:));
else %Variante I
    x=1*arg2:arg2:L/2*arg2;
    a=leastsquares_linear(x,var_dark);
    var_dark_0=a(2);
end
end
