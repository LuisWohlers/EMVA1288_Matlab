function [darkcurrent_var_DN,var_offset,dCvarFigure] = darkCurrent_fromvariance(input,interval_s,sigma_d,K)
%nach EMVA 1288 Release 3.1 Abschnitt 7.1 S.20
%-> kein Plot <-
%zur Bestimmung des Dunkelstroms aus einer MxNx2L-Matrix (input) aus 2L Bildern bei L
%verschiedenen Belichtungszeiten, jeweils zwei Bilder pro Belichtungszeit
%Abstände zwischen Belichtungszeiten (interval (in s)) müssen gleich sein (siehe "at least
%six equally spaced exposure times must be chosen"
%-> Variante zur Bestimmung aus VARIANZ
%(Formel (20))
%Einheit: DN^2/s

[~,~,L]=size(input);

%Varianzen ausrechnen
vector_vars=transpose(squeeze(var(input,1,[1 2])));
%vector_vars=sqrt((transpose(squeeze(var(input,1,[1 2])))-sigma_d^2*K)/K);

%erste Belichtungszeit: ein mal intervall,
%letzte Belichtungszeit: L mal intervall (in s)
x=1*interval_s:interval_s:L*interval_s;

%Lineare Regression
a = leastsquares_linear(x,vector_vars);
darkcurrent_var_DN=a(1);%in DN^2/s
var_offset=a(2);

dCvarFigure=figure('Name','Dark current from variance');
figure(dCvarFigure);
plot(x,vector_vars);
hold on;
y_fit=polyval(a,x);
plot(x,y_fit,'r--');
title('Dark current from variance','FontSize',12);
xlabel('exposure time [s]','FontSize',12);
ylabel('\sigma^2 [DN^2]','FontSize',12);
legend('Data','Fit','Location','Northwest');
hold off;

end

