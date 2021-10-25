function output = temporalvariance_grayvalue(imgA,imgB)
%nach EMVA 1288 Release 3.1 Formel (29), S.16, Ausgabe double
[M,N]=size(imgA);
subtract=(double(imgA)-double(imgB)).^2;
output=1/(2*N*M)*sum(subtract(:));
end

