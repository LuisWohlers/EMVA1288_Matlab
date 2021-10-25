function gigecam_exposurestep_L_images(L,exposurestep,folder,imagesname,blacklevel,gain)
%nimmt mit der Kamera am GigE-Adapter 2L Bilder auf mit
%L Schritten der Belichtungszeit "exposurestep" von 1*exposurestep bis
%L*exposurestep, je zwei Bilder pro Stufe
%Bilder werden im Ordner "folder" (vollständie Adresse benötigt) gespeichert 
%und benannt nach imagesname+Schritt+a/b
%uint16, 12bit (Kamera)
warning('off');
mkdir(folder);
imaqreset
g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain);
for i=1:1:L
    while 1
        try
        g.ExposureTimeAbs=i*exposurestep;
        for z=1:1:4
            snapshot(g);
        end
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

g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain);
for j=1:1:L
    while 1
        j
        try 
        g.ExposureTimeAbs=j*exposurestep;
        for z=1:1:4
            snapshot(g);
        end
        while 1  
            g.ExposureTimeAbs=j*exposurestep;
            pause(0.5);           
            test=g.ExposureTimeAbs;
            if test ~=j*exposurestep
                error('');
            end
            imgs(:,:,L+j)=snapshot(g);
                      
            test=g.ExposureTimeAbs;
            if test ~= j*exposurestep
                error('');
            else
                break;
            end
        end
        break;      
        catch
            clear g;
            clear image2;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',j*exposurestep);
        end
    end
end
clear g;


for k=1:1:L
    fid=fopen([folder '\' imagesname num2str(k,'%03d') 'a.raw'],'w+');
    fwrite(fid,imgs(:,:,k).','uint16');
    fclose(fid);  
    fid=fopen([folder '\' imagesname num2str(k,'%03d') 'b.raw'],'w+');
    fwrite(fid,imgs(:,:,i+k).','uint16');
    fclose(fid);
end
clear imgs;
warning('on');
end



