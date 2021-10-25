function [fig_vertical,fig_horizontal] = profiles(img_dark,img_50)
%nach EMVA 1288 Release 3.1 Abschnitt 8.3 S.25
[M,N]=size(img_dark);

%Horizontal

%DSNU
middle_DSNU=middle_row(img_dark,M);
mean_cols_DSNU=mean(img_dark,1);
max_cols_DSNU=max(img_dark,[],1);
min_cols_DSNU=min(img_dark,[],1);

%PRNU
middle_PRNU=middle_row(img_50-img_dark,M);
mean_cols_PRNU=mean(img_50-img_dark,1);
max_cols_PRNU=max(img_50-img_dark,[],1);
min_cols_PRNU=min(img_50-img_dark,[],1);

fig_horizontal=figure('Name','Horizontal Profiles');
figure(fig_horizontal);
%Plot
%PRNU
t=tiledlayout(2,1);
ax1=nexttile;
x=0:1:N-1;
plot(x,middle_PRNU)
hold on;
plot(x,min_cols_PRNU)
plot(x,max_cols_PRNU)
plot(x,mean_cols_PRNU)
ylim([0.9*mean(mean_cols_PRNU) 1.1*mean(mean_cols_PRNU)])
xlim([-10 N+10])
title('PRNU')
hold off;

%DSNU
ax2=nexttile;
x=0:1:N-1;
plot(x,middle_DSNU)
hold on;
plot(x,min_cols_DSNU)
plot(x,max_cols_DSNU)
plot(x,mean_cols_DSNU)
ylim([0.9*mean(min_cols_DSNU) 1.1*mean(max_cols_DSNU)])
xlim([-10 N+10])
title('DSNU')
hold off;
linkaxes([ax1,ax2],'x');
title(t,'Horizontal profiles','FontSize',12)
ylabel(t,'Vertical line [DN]','FontSize',12)
xlabel(t,'Index of the line','FontSize',12)
xticklabels(ax1,{})
legend('Mid','Min','Max','Mean');


%Vertikal
%DSNU
middle_vert_DSNU=middle_row(transpose(img_dark),N);
mean_rows_DSNU=mean(img_dark,2);
max_rows_DSNU=max(img_dark,[],2);
min_rows_DSNU=min(img_dark,[],2);

%PRNU
middle_vert_PRNU=middle_row(transpose(img_50-img_dark),N);
mean_rows_PRNU=mean(img_50-img_dark,2);
max_rows_PRNU=max(img_50-img_dark,[],2);
min_rows_PRNU=min(img_50-img_dark,[],2);

fig_vertical=figure('Name','Vertical Profiles');
figure(fig_vertical);
%Plot
%DSNU
t2=tiledlayout(1,2);
ax3=nexttile;
y=0:1:M-1;
plot(middle_vert_DSNU,y);
hold on;
plot(min_rows_DSNU,y);
plot(max_rows_DSNU,y);
plot(mean_rows_DSNU,y);
xlim([0.9*mean(min_rows_DSNU) 1.1*mean(max_rows_DSNU)])
ylim([-10 M+10])
title('DSNU')
hold off;

%PRNU
ax4=nexttile;
y=0:1:M-1;
plot(middle_vert_PRNU,y);
hold on;
plot(min_rows_PRNU,y);
plot(max_rows_PRNU,y);
plot(mean_rows_PRNU,y);
xlim([0.9*mean(mean_rows_PRNU) 1.1*mean(mean_rows_PRNU)])
ylim([-10 M+10])
title('PRNU')
hold off;


linkaxes([ax3,ax4],'y');
title(t2,'Vertical profiles','FontSize',12)
xlabel(t2,'Vertical line [DN]','FontSize',12)
ylabel(t2,'Index of the line','FontSize',12)
yticklabels(ax3,{})
legend('Mid','Min','Max','Mean');


end

