function output = mean_grayvalue(imgA,imgB)
%nach EMVA 1288 Release 3.1 Formel (28), S.15, Ausgabe double
%für jeweils zwei Bilder pro Stufe
[M,N]=size(imgA);
imgA=double(imgA);
imgB=double(imgB);
img_sum=imgA+imgB;
output = 1/(2*N*M)*double(sum(img_sum(:)));
end

