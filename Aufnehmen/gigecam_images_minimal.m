function gigecam_images_minimal(exposuretime,folder,imagesname,blacklevel,gain)
%zwei Bilder bei einer Belichtungszeit
%uint16, 12bit (Kamera)
mkdir(folder);
imaqreset
g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',exposuretime);
for i=1:1:2
    success=0;
    disp(i);
    
    while ~success
        try           
   
        image=uint16(snapshot(g));

        success=1;        
        catch
            clear g;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',exposuretime);
            success=0;
        end
    end

    fid=fopen([folder '\' imagesname num2str(i,'%03d') '.raw'],'w+');
    fwrite(fid,image.','uint16');
    fclose(fid);  
end
clear g;
end
