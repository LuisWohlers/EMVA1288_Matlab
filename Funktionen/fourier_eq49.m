function output = fourier_eq49(y)
%Subtraktion des Mittelwerts und darauffolgend Berechnung der
%Fouriertransformierten der Zeilen eines Bildes entsprechend Formel
%(49), S.22 EMVA 1288 Release 3.1
%y: MxN-Bild

%1. Schritt
y=double(y);
mean=mean_singleimage(y);

y=y-mean;

%2.Schritt (Formel (49)), Fourier-Transformationen der Zeilen
output=ones(size(y));
[M,N]=size(y);
for m=1:M
%     for v=1:N
%           output(m,v)=1/sqrt(N)*sum(y(m,1:1:N).*exp(-(2*pi*1i.*(1:1:N).*v)/N),'all');
%     end
    output(m,:)=1/sqrt(N)*fft(y(m,:));
end
end

