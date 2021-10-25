function fig = logarithmic_histogram_PRNU(avg_img_dark,avg_img_50,L)
%Logarithmisches Histogram nach EMVA 1288 Release 3.1 Abschnitt 8.4
%Schritte 1-5

y=highpass_C5(avg_img_50-avg_img_dark);
ymin=min(y(:));
ymax=max(y(:));

I=floor(L*(abs(ymax-ymin))/256)+1;
Q=floor(L*(abs(ymax-ymin))/I) + 1;
[M,N]=size(y);

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
%y_q=y_q/mean_singleimage(avg_img_50)*100;

fig=figure('Name','Logarithmic Histogram PRNU');
figure(fig);
%durchgängige Linie erzwingen mit max(eps, bins) -> Werte 0 werden auf
%kleinste darstellbare Zahl gesetzt
semilogy(y_q,max(eps, bins));

ylim([0.5 max(bins)*2]);

%Schritt 5: 
var_nw=spatialvariance_singleimage(y,mean_singleimage(y));
p_normal=(I/L)*(N*M)/(sqrt(2*pi)*sqrt(var_nw))*exp(-(y_q.^2)/(2*var_nw));
hold on;
semilogy(y_q,p_normal,'-.')

title('Logarithmic histogram PRNU','FontSize',12);
xlabel('Deviation from the mean','FontSize',12);
ylabel('Number of pixels','FontSize',12);
legend('Data','Model');
hold off;


end

