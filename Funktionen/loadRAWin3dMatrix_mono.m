function output = loadRAWin3dMatrix_mono(folder_name,cols,rows)
%lädt L RAW-Dateien aus Adresse "folder_name" in eine 3d-Matrix MxNxL
%Ordner muss RAW-Dateien enthalten
%output: MxNxL-Matrix

%Dateien öffnen: https://de.mathworks.com/matlabcentral/answers/284135-how-to-open-the-files-in-a-directory
direction = dir(fullfile(folder_name));%Ordner 
direction([direction.isdir]) = [];%Ordnernamen extrahieren
filecount=length(direction);%Anzahl der Dateien im Ordner

output=double(zeros(rows,cols,filecount));

for i=1:filecount
    filename=fullfile(folder_name, direction(i).name);
    file=fopen(filename,'r');
    this_img=double(fread(file, [cols, rows], 'uint16'));
    
    %transponieren, Breite x Höhe in Zeilen x Spalten (= "höhe x Breite")
    output(:,:,i)=transpose(this_img);%jeweiliges Bild an Matrix anhängen
    fclose(file);
end

end

