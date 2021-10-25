function blacklevel = calculate_BlackLevelOffset_gigecam(gain)
%nach EMVA 1288 Release 3.1 S.15
%Offset setzen, sodass weniger als 0.5% der Werte 0 sind
imaqreset;
warning('off');

g=gigecam(1,'PixelFormat','Mono12','Timeout',100,'PacketSize',9014,'PacketDelay',18000,'ExposureTimeAbs',10,'Gain',gain);
bL=0;
zeros=1;
while(zeros>=0.2)

   try           

   g.BlackLevel=bL;
       
   catch
        clear g;
        g=gigecam(1,'PixelFormat','Mono12','Timeout',100,'PacketSize',9014,'PacketDelay',18000,'ExposureTimeAbs',10,'BlackLevel',bL,'Gain',gain);
   end
     
   success=0;
   while ~success
        try           

        frame=uint16(snapshot(g));

        success=1;        
        catch
            clear g;
            g=gigecam(1,'PixelFormat','Mono12','Timeout',100,'PacketSize',9014,'PacketDelay',18000,'ExposureTimeAbs',10,'BlackLevel',bL,'Gain',gain);
            success=0;
        end
   end
   bL=bL+1;
   
   zeros=(sum(frame(:)==0)/numel(frame))*100;  
end

blacklevel=bL-1;
clear g;
warning('on');
end

