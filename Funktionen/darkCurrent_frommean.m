function [darkcurrent_mean_DN,darkcurrent_mean_offset,dCmeanFigure] = darkCurrent_frommean(input,interval)
%nach EMVA 1288 Release 3.1 Abschnitt 7.1 S.20
%-> kein Plot <-
%zur Bestimmung des Dunkelstroms aus einer MxNx2L-Matrix (input) aus 2L Bildern bei L
%verschiedenen Belichtungszeiten, jeweils zwei Bilder pro Belichtungszeit
%Abstände zwischen Belichtungszeiten (interval (in s)) müssen gleich sein (siehe "at least
%six equally spaced exposure times must be chosen"
%-> Variante zur Bestimmung aus MITTELWERT
%(Formel (19))
%Einheit: DN/s

[~,~,L]=size(input);

%Mittelwerte ausrechnen
vector_means=transpose(squeeze(mean(input,[1 2])));

%erste Belichtungszeit: ein mal intervall,
%letzte Belichtungszeit: L mal intervall (in s)
x=1*interval:interval:L*interval;

%Lineare Regression
a = leastsquares_linear(x,vector_means);
darkcurrent_mean_DN=a(1);%DN/s
darkcurrent_mean_offset=a(2);

dCmeanFigure=figure('Name','Dark current from mean');
figure(dCmeanFigure);
plot(x,vector_means);
hold on;
y_fit=polyval(a,x);
plot(x,y_fit,'r--');
title('Dark current from mean','FontSize',12);
xlabel('exposure time [s]','FontSize',12);
ylabel('\mu [DN]','FontSize',12);
legend('Data','Fit','Location','Northwest');
hold off;

end
