function [R,p_sat,fig] = sensitivity_curve(input,photonsperstep,mean_dark,var_dark)
%input: MxNxL-Matrix
%mean_dark,var_dark: für Messvariante I (nur eine Belichtungszeit) je ein Wert
%                   für Messvariante II je ein Wert pro
%                   Belichtungsstufe -> 1xL-Vektor
%EMVA 1288 Release 3.1 S.16
%Rückgabe: responsivity R, p_sat

%jeweils zwei Bilder pro Stufe
[~,~,numberofsteps]=size(input);

%array für y-Achse (mean-mean_dark) und
%array für Varianz (für Sättigung) (var-var_dark)
[y,var]=mean_and_temporalvariance(input,mean_dark,var_dark);

%array für x-Achse 
x=1:1:numberofsteps/2;
x=x*photonsperstep;

fig=figure('Name','Sensitivity');
figure(fig);
plot(x,y);
hold on;
title('Sensitivity','FontSize',12);
xlabel('\mu_p [mean number of photons per pixel]','FontSize',12);
ylabel('\mu_y - \mu_y_._d_a_r_k [DN]','FontSize',12);

%Sättigung 
mgv_sat=saturation(y,var);

%Photonen pro Pixel bei Sättigung
idx=find(y > mgv_sat,1,'first')-1;
p_sat=x(idx);

%0-70%-Range wird für Lineare Regression genutzt
sat_70_percent=0.7*mgv_sat;

idx2=find(y>sat_70_percent,1,'first')-1;

y_tofit=y(1:idx2);
x_tofit=x(1:idx2);

fit=polyfit(x_tofit,y_tofit,1);
y_draw = polyval(fit,x);
plot(x,y_draw,'r--');

range_marker_color=[1,0,0];
plot(x(idx2-1),y(idx2-1),'.','MarkerSize',20,'color',range_marker_color);
plot(x(1),y(1),'.','MarkerSize',20,'color',range_marker_color);

legend('Data','Fit','Fit Range','Location','northwest');


hold off;

%Steigung der Ausgleichsgeraden ist die sensitivity R
R=fit(1);

end

