function output = spatialvariance_singleimage(img, mean)
%nach EMVA 1288 Release 3.1 S.9 Formel (23) / (24)
[M,N]=size(img);
img=double(img)-double(mean);
squared=img.^2;
output=1/(M*N-1)*sum(squared(:));

end

