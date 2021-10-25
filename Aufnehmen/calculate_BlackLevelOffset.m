function blacklevel = calculate_BlackLevelOffset(vid,src,rows,cols)
%nach EMVA 1288 Release 3.1 S.15
%Offset setzen, sodass weniger als 0.5% der Werte 0 sind
%vid: videoinput-Objekt
%src: getselectedsource(vid)

pixels=rows*cols;
src.BlackLevel=0;
frame=getsnapshot(vid);
zeros=(sum(frame(:)==0)/pixels)*100;

while(zeros>=0.5)
   src.BlackLevel=src.BlackLevel+1;
   frame=getsnapshot(vid);
   zeros=(sum(frame(:)==0)/pixels)*100;  
end

blacklevel=src.BlackLevel;

end


