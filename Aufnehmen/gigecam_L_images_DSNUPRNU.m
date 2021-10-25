function gigecam_L_images_DSNUPRNU(L,exposuretime,folder,imagesname,blacklevel,gain)
%uint16, 12bit (Kamera)
warning('on');
mkdir(folder);
imaqreset
g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',exposuretime);
for i=1:1:L
    while 1
        try
        imgs(:,:,i)=snapshot(g);
        break;
        catch
            clear g;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'BlackLevel',blacklevel,'Gain',gain,'ExposureTimeAbs',exposuretime);
        end
    end
end
clear g;

for i=1:1:L
    fid=fopen([folder '\' imagesname num2str(i,'%03d') '.raw'],'w+');
    fwrite(fid,imgs(:,:,i).','uint16');
    fclose(fid); 
end

end


