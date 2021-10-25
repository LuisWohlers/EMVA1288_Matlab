function [a] = leastsquares_linear(x,y)
%Berechnung der Koeffizienten a_0 und a_1 nach der Methode der kleinsten
%Quadrate, https://de.wikipedia.org/wiki/Methode_der_kleinsten_Quadrate#Das_Verfahren

xmean=mean(x);
ymean=mean(y);

x=x-xmean;
y=y-ymean;

xy_produkt=x.*y;
x_quadrat=x.^2;
zaehler=sum(xy_produkt(:));
nenner=sum(x_quadrat(:));
if(nenner~=0)
    a(1)=zaehler/nenner; %slope
    a(2)=ymean-(zaehler/nenner)*xmean; %offset
else
    a(1)=0;
    a(2)=ymean;
end
end

