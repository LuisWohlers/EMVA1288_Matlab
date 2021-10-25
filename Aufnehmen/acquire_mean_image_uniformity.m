function image=acquire_mean_image_uniformity(cols,rows,L,exposuretime)
imaqreset
g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'ExposureTimeAbs',exposuretime);
images=zeros(rows,cols,L);
for i=1:1:L
    success=0;
    disp(i);
    while ~success
        try           
   
        images(:,:,i)=uint16(snapshot(g));

        success=1;        
        catch
            clear g;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',10,'PacketSize',9014,'PacketDelay',18000,'ExposureTimeAbs',exposuretime);
            success=0;
        end
    end
end
image=mean(images,3);
clear images;
clear g;
end

