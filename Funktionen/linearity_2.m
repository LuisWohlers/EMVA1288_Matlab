function [LE_min,LE_max,fig_lin,fig_dev] = linearity_2(input,photonsperstep,mean_dark,var_dark)
%nach EMVA 1288 S.18 und 19 
%input: MxNxL-Matrix
%mean_dark,var_dark: für Messvariante I (nur eine Belichtungszeit) je ein Wert
%                   für Messvariante II je ein Wert pro
%                   Belichtungsstufe -> 1xL-Vektor

%jeweils zwei Bilder pro Stufe
[~,~,numberofsteps]=size(input);

%array für y-Achse (mean-mean_dark) und Array für Varianz (var-var_dark)
[y,var]=mean_and_temporalvariance(input,mean_dark,var_dark);

%array für x-Achse 
x=1:1:numberofsteps/2;
x=x*photonsperstep;


fig_lin=figure('Name','Linearity');
figure(fig_lin);
plot(x,y);
hold on;
title('Linearity','FontSize',12);
xlabel('\mu_p [mean number of photons per pixel]','FontSize',12);
ylabel('\mu_y - \mu_y_._d_a_r_k [DN]','FontSize',12);

%Sättigung 
mgv_sat=saturation(y,var);

%5-95%-Range wird für Lineare Regression genutzt
%idx_lower: Unteres Ende der Fit Range
%idx_lower: Oberes Ende der Fit Range
sat_05_percent=0.05*mgv_sat;
sat_95_percent=0.95*mgv_sat;

idx_lower=find(y>=sat_05_percent,1,'first');
idx_upper=find(y>sat_95_percent,1,'first')-1;

x_tofit=x(idx_lower:idx_upper);
y_tofit=y(idx_lower:idx_upper);


fit=polyfit(x_tofit,y_tofit,1);
y_draw = polyval(fit,x);
plot(x,y_draw,'r--');

range_marker_color=[1,0,0];
plot(x(idx_upper),y(idx_upper),'.','MarkerSize',20,'color',range_marker_color);
plot(x(idx_lower),y(idx_lower),'.','MarkerSize',20,'color',range_marker_color);

legend('Data','Fit','Fit Range','Location','northwest');


hold off;

%a_0 und a_1 mit den Formeln (35) und (36) sowie (37) berechnen
[a_0,a_1]=regression_EMVA1288(x_tofit,y_tofit);
%Deviation Linearity
%x-Achse: x_tofit

%y-Achse: in Prozent, Berechnung nach Formel (38), S.20
dev_percent=100.*(y_tofit-(a_0+a_1.*x_tofit))./(a_0+a_1.*x_tofit);

fig_dev=figure('Name','Deviation linearity');
figure(fig_dev);
plot(x_tofit,dev_percent);
hold on;

title('Deviation linearity','FontSize',12);
xlabel('\mu_p [mean number of photons per pixel]','FontSize',12);
ylabel('Linearity Error LE [%]','FontSize',12);

n=length(x_tofit);
plot(x_tofit(1),dev_percent(1),'.','MarkerSize',20,'color',range_marker_color);
plot(x_tofit(n),dev_percent(n),'.','MarkerSize',20,'color',range_marker_color);
legend('Data','Fit Range','Location','northeast');
hold off;

%Minimale und maximale Abweichung in Prozent
LE_min=min(dev_percent);
LE_max=max(dev_percent);
end

