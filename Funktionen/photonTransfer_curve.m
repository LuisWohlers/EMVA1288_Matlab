function [K,fig] = photonTransfer_curve(input,mean_dark,var_dark)
%input: MxNxL-Matrix, jeweils 2 Bilder pro Stufe (0.5L Belichtungsstufen)
%mean_dark,var_dark: für Messvariante I (nur eine Belichtungszeit) je ein Wert
%                   für Messvariante II je ein Wert pro
%                   Belichtungsstufe -> 1xL-Vektor
%EMVA 1288 Release 3.1 S.17 

%jeweils zwei Bilder pro Stufe

%array für x-Achse (mean-mean_dark) und
%array für y-Achse (var-var_dark)
[x,y]=mean_and_temporalvariance(input,mean_dark,var_dark);


%Plot
fig=figure('Name','Photon Transfer');
figure(fig);
plot(x,y);
hold on;
title('Photon Transfer','FontSize',12);
xlabel('\mu_y - \mu_y_._d_a_r_k [DN]','FontSize',12);
ylabel('\sigma_y^2 - \sigma_y_._d_a_r_k^2 [DN^2]','FontSize',12);

%Sättigung durch Punkt kennzeichnen
[mgv_sat,var_sat]=saturation(x,y);
sat_marker_color=[0,1,0];
plot(mgv_sat,var_sat,'.','MarkerSize',20,'color',sat_marker_color);


%0-70%-Range wird für Lineare Regression genutzt
sat_70_percent=0.7*mgv_sat;
idx=find(x>sat_70_percent,1,'first')-1;

y_tofit=y(1:idx);
x_tofit=x(1:idx);

%fit=polyfit(x_tofit,y_tofit,1);
fit=leastsquares_linear(x_tofit,y_tofit);
y_draw = polyval(fit,x);
plot(x,y_draw,'r--');

range_marker_color=[1,0,0];
plot(x(idx-1),y(idx-1),'.','MarkerSize',20,'color',range_marker_color);
plot(x(1),y(1),'.','MarkerSize',20,'color',range_marker_color);

legend('Data','Saturation','Fit','Fit Range','Location','northwest');
hold off;

%Die Steigung der Geraden "y_draw" ist der Verstärkungsfaktor K
K=fit(1);

end
