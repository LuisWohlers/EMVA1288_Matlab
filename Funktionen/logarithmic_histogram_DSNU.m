function fig = logarithmic_histogram_DSNU(avg_img_dark,L,spatial_var_dark)
%Logarithmisches Histogram nach EMVA 1288 Release 3.1 Abschnitt 8.4
%Schritte 1-5

%DSNU
y=avg_img_dark;
ymin=abs(min(y(:)));
ymax=abs(max(y(:)));
I=floor(L*(ymax-ymin)/256) + 1;
Q=floor(L*(ymax-ymin)/I) + 1;
% width=I/L;
[M,N]=size(avg_img_dark);

bins=zeros(1,Q);

for m=1:M
    for n=1:N
        increment_this_bin=floor(L*(y(m,n)-ymin)/I)+1;
        bins(increment_this_bin)=bins(increment_this_bin)+1;
    end
end
q=0:1:Q-1;
y_q=ymin +(I-1)/(2*L)+q*(I/L);
y_q=y_q-mean_singleimage(y);


fig = figure('Name','Logarithmic Histogram DSNU');
figure(fig);
%durchgängige Linie erzwingen mit max(eps, bins) -> Werte 0 werden auf
%kleinste darstellbare Zahl gesetzt
semilogy(y_q,max(eps, bins));

%Schritt 5: 
p_normal=(I/L)*(N*M)/(sqrt(2*pi)*sqrt(spatial_var_dark))*exp(-(y_q.^2)/(2*spatial_var_dark));
hold on;
semilogy(y_q,p_normal,'-.')
ylim([0.5 max(bins)]);
title('Logarithmic histogram DSNU','FontSize',12);
xlabel('Deviation from the mean [DN]','FontSize',12);
ylabel('Number of pixels','FontSize',12);
legend('Data','Model');
hold off;


end

