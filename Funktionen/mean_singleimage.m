function output = mean_singleimage(img)
%Mittelung über alle Pixel eines einzelnen Bildes nach EMVA 1288 Release
%3.1 S.9 Formel (22)
[M,N]=size(img);
img=double(img);

output=1/(M*N)*sum(img(:));

end

