function acquire_images_dsnu_prnu(L,exp_50,folder,gain,blacklevel)
%Bilderserien für DSNU und PRNU 
%50% Sättigung wird über Belichtungszeit exp_50 erreicht (asugerechnet aus
%Funktion in EMVA-Klasse)
%L: Anzahl der Bilder

%DSNU
input("Make sure the light source is turned off, then press return to continue");
WinPower('monitor','off');
gigecam_L_images_DSNUPRNU(L,exp_50,[folder '\images_dsnu'],'images_dsnu',blacklevel,gain);
WinPower('monitor','on');
%PRNU
input("Turn the light source on, then press return to continue");
WinPower('monitor','off');
gigecam_L_images_DSNUPRNU(L,exp_50,[folder '\images_prnu'],'images_prnu',blacklevel,gain);
WinPower('monitor','on');
end
