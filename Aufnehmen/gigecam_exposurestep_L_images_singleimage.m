function gigecam_exposurestep_L_images_singleimage(L,exposurestep,folder,imagesname,blacklevel,gain)
%nimmt mit der Kamera am GigE-Adapter L Bilder auf mit
%L Schritten der Belichtungszeit "exposurestep" von 1*exposurestep bis
%L*exposurestep, je ein Bild pro Stufe
%Bilder werden im Ordner "folder" (vollständie Adresse benötigt) gespeichert 
%und benannt nach imagesname+Schritt+a/b
warning('off');
mkdir(folder);
imaqreset
g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain);
for i=1:1:L
    while 1
        try
        g.ExposureTimeAbs=i*exposurestep;
        snapshot(g);
        while 1 
            i
            g.ExposureTimeAbs=i*exposurestep;
            pause(0.5);
            test=g.ExposureTimeAbs;
            if test ~= i*exposurestep
                error('');
            end
            imgs(:,:,i)=snapshot(g);
                      
            test=g.ExposureTimeAbs;
            if test ~= i*exposurestep
                error('');
            else
                break;
            end
        end
        break;      
        catch
            clear g;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',i*exposurestep);
        end
    end
end
clear g;


for k=1:1:L
    fid=fopen([folder '\' imagesname num2str(k,'%03d') '.raw'],'w+');
    fwrite(fid,imgs(:,:,k).','uint16');
    fclose(fid);  
end
clear imgs;
warning('on');
end



