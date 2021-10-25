function [spatial_var_whitenoise,fig] = spectrogram(image_dark,image_50,horizontal_vertical,DSNU_or_PRNU,XXXX,var_stack,K)
%Spektrogram nach EMVA 1288 Release 3.1 S.22 Aschnitt 8.2
%image_dark: Mittelwertbild dunkel
%image_50: für PRNU aus Mittelwertbild 50% - Mittelwertbild dunkel


switch DSNU_or_PRNU
    case 'PRNU'
        input=image_50-image_dark;
        means=mean_singleimage(image_50)-mean_singleimage(image_dark);
    case 'DSNU'
        input=image_dark;
end

[~,N]=size(input);

switch horizontal_vertical
    case 'vertical'
        horizontal_vertical = 'Vertical';
        fourier_input=fourier_eq49(transpose(input));
        power_spec=power_spectrum_eq50(fourier_input);
    case 'horizontal'
        horizontal_vertical = 'Horizontal';
        fourier_input=fourier_eq49(input);
        power_spec=power_spectrum_eq50(fourier_input);
end


%PRNU: Spektrogram durch Mittelwert teilen (siehe 8.2.4)
switch DSNU_or_PRNU
    case 'PRNU'
        power_spec_PRNU=power_spec/means;
        sq_ps=sqrt(power_spec_PRNU);
    case 'DSNU'
        sq_ps=sqrt(power_spec);
end

fig=figure('Name',append(horizontal_vertical,' spectrogram ',DSNU_or_PRNU));
figure(fig);

v=0:1:N/2-1;
v=v/N;
color_Data=[0,0,1];
semilogy(v,sq_ps(1:N/2),'color',color_Data);
hold on;

color_XXXX=[1,0,0];
color_var=[0,1,0];
switch DSNU_or_PRNU
    case 'DSNU'
        %DSNU ist in e^- , umrechnen in DN
        XXXX=XXXX*K;
        yline(XXXX,'-.','color',color_XXXX,'LineWidth',2);
        
        %var_stack ist Varianz -> Standardabweichung = sqrt(var_stack)
        yline(sqrt(var_stack),'-.','color',color_var,'LineWidth',2);
        
        title(append(horizontal_vertical,' spectrogram DSNU'),'FontSize',12);
        xlabel('cycles [periods/pixel]','FontSize',12);
        ylabel({'Standard deviation and', 'relative presence of each cycle [DN]'},'FontSize',12);
        legend('Data','DSNU_1_2_8_8_._D_N','\sigma_y_._s_t_a_c_k_._d_a_r_k');
    case 'PRNU'
        %PRNU ist in % eingegeben
        yline(XXXX,'-.','color',color_XXXX);
        yline(sqrt(var_stack),'-.','color',color_var);
        
        %var_stack ist Varianz -> Standardabweichung = sqrt(var_stack)
        yline(sqrt(var_stack),'-.','color',color_var,'LineWidth',2);
        
        title(append(horizontal_vertical,' spectrogram PRNU'),'FontSize',12);
        xlabel('cycles [periods/pixel]','FontSize',12);
        ylabel({'Standard deviation and', 'relative presence of each cycle [%]'},'FontSize',12);
        legend('Data','PRNU_1_2_8_8','\sigma_y_._s_t_a_c_k');
end
        



hold off;

%nach Abschnitt 8.2.6
%Median des Leistungsdichtespektrums
spatial_var_whitenoise=median(power_spec);
end

