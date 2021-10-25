function output = average_image_3dmat(input)
%berechnet gemitteltes Grauwert-Bild aus MxNxL-Matrix
%zur Berechnung von DSNU und PRNU nach EMVA 1288 Release 3.1

[~,~,L]=size(input);
input=double(input);

output=1/L*sum(input,3);

end
