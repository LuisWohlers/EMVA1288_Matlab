function vidinput_exposurestep_L_images(L,exposurestep,folder,imagesname)
%nimmt mit der Kamera am GigE-Adapter 2L Bilder auf mit
%L Schritten der Belichtungszeit "exposurestep" von 1*exposurestep bis
%L*exposurestep, je zwei Bilder pro Stufe
%Bilder werden im Ordner "folder" (vollständie Adresse benötigt) gespeichert 
%und benannt nach imagesname+Schritt+a/b
%uint16, 12bit (Kamera)
mkdir(folder);
imaqreset
vid=videoinput('gige',1,'Mono12');
src = getselectedsource(vid);
src.PacketSize=7000;
src.PacketDelay=10000;
set(vid,'Timeout',100000);
for i=1:1:L
    disp(i);
    src.ExposureTimeAbs=i*exposurestep;

    image1=getsnapshot(vid);
    image2=getsnapshot(vid);

    fid=fopen([folder '\' imagesname num2str(i,'%03d') 'a.raw'],'w+');
    fwrite(fid,image1.','uint16');
    fclose(fid);  
    fid=fopen([folder '\' imagesname num2str(i,'%03d') 'b.raw'],'w+');
    fwrite(fid,image2.','uint16');
    fclose(fid);
end
clear src
delete(vid);
end


