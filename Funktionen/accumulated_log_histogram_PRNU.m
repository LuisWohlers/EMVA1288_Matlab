function fig = accumulated_log_histogram_PRNU(avg_img_dark,avg_img_50,L)
%Akkumuliertes logarithmisches Histogram nach EMVA 1288 Release 3.1
%Abschnitt 8.4

%Hochpass
y=highpass_C5(avg_img_50-avg_img_dark);

%Schritt 1 (Formel (56))
y=abs(y-mean_singleimage(y));

%Schritt 2
ymax=max(y(:));

%Schritt 3
I=floor(L*(ymax)/256)+1;
Q=floor(L*(ymax)/I) + 1;


[M,N]=size(y);

%Schritt 4
bins=zeros(1,Q);

for m=1:M
    for n=1:N
        increment_this_bin=floor(L*y(m,n)/I)+1;
        bins(increment_this_bin)=bins(increment_this_bin)+1;
    end
end

q=0:1:Q-1;
y_q=(I-1)/(2*L)+q*(I/L);

%Schritt 6

H_q=cumsum(bins,'reverse');

%Plot
fig=figure('Name','Accumulated log Histogram PRNU');
figure(fig);
semilogy(y_q,H_q)
ylim([0.5 max(H_q)+10^5]);
title('Accumulated log histogram PRNU','FontSize',12);
xlabel('Minimal deviation from the mean','FontSize',12);
ylabel({'Percentage of pixels', 'deviating from the mean at least of:'},'FontSize',12);
legend('Data');

end

