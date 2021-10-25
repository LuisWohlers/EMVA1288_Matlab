function [SNR_max,DR,fig] = plot_SNR(input,photonsperstep,p_min,p_sat,e_sat,temp_dark_noise,var_quantisation,K,quantum_efficiency,DSNU,PRNU,mean_dark)
%nach EMVA 1288 S.18, Abschnitt SNR
%SNR nach Formel (10), S.6 -> SNR_mv_EMVA1288.m
%input: MxNxL-Matrix
%photonsperstep: zusätzliche Anzahl Photonen pro Schritt
%p_min: absolute sensitivity threshold
%p_sat: saturation capacity

%erste zwei Bildern: dunkle Bilder 
mean_dark=mean_grayvalue(input(:,:,1),input(:,:,2));

%danach jeweils zwei Bilder pro Stufe
[~,~,numberofsteps]=size(input);


%array für y-Achse: SNR = (mean_y-mean_dark)/sqrt(var_y)
y=SNR_mv_EMVA1288(input,mean_dark);

%array für SNR - x-Achse 
x=1:1:numberofsteps/2-1;
x=x*photonsperstep;


%array für ideales SNR - x-Achse 
x_ideal=(0:1:numberofsteps/2)*photonsperstep;
%Erster Wert wegen logarithmischer Darstellung >0
x_ideal(1)=photonsperstep/100;

%ideales SNR aus Formel (13)
y_SNR_ideal=sqrt(x_ideal);


%Theoretisches SNR nach Formel (11)
x_SNR_theoretical=10:100:(numberofsteps/2)*photonsperstep;
y_SNR_theoretical=quantum_efficiency.*x_SNR_theoretical.*1./sqrt((temp_dark_noise^2)+(var_quantisation/(K^2))+quantum_efficiency.*x_SNR_theoretical);

%Total SNR nach Formel (48)
x_SNR_total=10:100:round(p_sat);
y_SNR_total=quantum_efficiency.*x_SNR_total .* 1./sqrt((temp_dark_noise^2)+DSNU^2+(var_quantisation/(K^2))+quantum_efficiency.*x_SNR_total+(PRNU/100).^2.*(quantum_efficiency.*x_SNR_total).^2);

fig=figure('Name','SNR');
figure(fig);
loglog(x,y,'.','MarkerSize',12);
hold on;

loglog(x_ideal,y_SNR_ideal,'-.');

loglog(x_SNR_theoretical,y_SNR_theoretical,':','LineWidth',2);

loglog(x_SNR_total,y_SNR_total,':','LineWidth',2);

title('Signal to Noise Ratio','FontSize',12);
xlabel('\mu_p [mean number of photons per pixel]','FontSize',12);
ylabel('SNR','FontSize',12);

%mu_p_min und mu_p_sat kennzeichnen
xline(p_min,'color',[0,0,1]);
xline(p_sat,'color',[0,0.5,0.5]);

legend('Data','Ideal','Theoretical','Total SNR','\mu_p_._m_i_n','\mu_p_._s_a_t','Location','northwest');

hold off;

%nach Formel (33)
SNR_max=sqrt(e_sat);

%Dynamic Range nach Formel (18)
DR=p_sat/p_min;
end

