function [DSNU,PRNU,sv_50,sv_dark,avg_img_dark,avg_img_50,var_stack_dark,var_stack_50] = DSNU_PRNU(images_dark,images_50,K)
%nach EMVA 1288 Release 3.1 S.22
%Eingabe sind zwei MxNxL-Matrizen und der Verstärkungsfaktor K
%Rückgabe: DSNU, PRNU in %, Räumliche Varianzen nach S.21 Abschnitt 8.1,
%Mittelwert-Bilder dunkel und 50% Intensität, und stack-Varianzen

[~,~,L]=size(images_dark);

avg_img_dark=average_image_3dmat(images_dark);
avg_img_50=average_image_3dmat(images_50);

mean_dark=mean_singleimage(avg_img_dark);
mean_50=mean_singleimage(avg_img_50);


spatialvar_dark=spatialvariance_singleimage(avg_img_dark,mean_dark);
spatialvar_50=spatialvariance_singleimage(avg_img_50,mean_50);

var_stack_dark=stack_variance_3dmat(images_dark);
var_stack_50=stack_variance_3dmat(images_50);

%Korrektur nach S.21 Abschnitt 8.1
sv_dark = spatialvar_dark - var_stack_dark/L;
sv_50 = spatialvar_50 - var_stack_50/L;

DSNU=sqrt(sv_dark)/K;

%PRNU in Prozent
PRNU=100*sqrt(sv_50-sv_dark)/(mean_50-mean_dark);
end

