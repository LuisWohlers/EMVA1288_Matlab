function [illuminationsteps,exposurestep_us,blacklevel,photonsactual] = acquire_images_mv_dc(photonsperstep,irradiance,lambda,pixel_area,folder,gain,N_DC)
%Bilderserien für Linearität und Sensitivity sowie dark current aufnehmen nach Variante I (variable Belichtungszeit)
%photonsperstep: gewünschte Erhöhung der Photonen pro Belichtungsstufe
%folder: Name des übergeordneten Ordners, in dem die Ordner mit den verschiedenen
%Bildserien gespeichert werden
%irradiance: Bestrahlung des Sensors in uW/cm^2, gemessen mit Photodiode
%gain: Gain
%illuminationsteps: Anzahl der Belichtungsstufen bei der Aufnahme der
%photonsactual: mit berechneter Belichtungszeit (gerundet in us berechnete
%Anzahl an Photonen pro Schritt, die vom gewünschten Wert photonsperstep
%abweichen kann)
%Bildserien für Linearität und Sensitivität (Funktion gigecam_exposurestep_acquire_images) 
%bricht ab wenn der Mittelwert maximal ist)

input("Make sure the light source is turned off, then press return to continue");
WinPower('monitor','off');
blacklevel=calculate_BlackLevelOffset_gigecam(gain);
WinPower('monitor','on');
exposurestep_ms=calculate_exposuretime(photonsperstep,pixel_area,irradiance,lambda);

%in us umrechnen für Manta
exposurestep_us=round(exposurestep_ms*1000);
photonsactual=calculate_photons(pixel_area,irradiance,exposurestep_ms,lambda);

input("Turn the light source on, then press return to continue");
%Bilder bei verschiedenen Belichtungsstufen
WinPower('monitor','off');
illuminationsteps = gigecam_exposurestep_acquire_images(exposurestep_us,[folder '\images_mv'],'images_mv',blacklevel,gain);
WinPower('monitor','on');
input("Turn the light source off again, then press return to continue");
%dark images
WinPower('monitor','off');
gigecam_exposurestep_L_images(illuminationsteps,exposurestep_us,[folder '\images_dark_mv'],'images_dark_mv',blacklevel,gain);

%Bildserie für dark current - auch variierte Belichtungszeiten, aber
%längere als bei den vorherigen Serien, siehe S.20 Abschnitt 7.1
%(Release3.1) -> hier N_DC Bilder bei Belichtungszeiten bis 2s
gigecam_exposurestep_L_images_singleimage(N_DC,100000,[folder '\images_dc'],'images_dc',blacklevel,gain);
WinPower('monitor','on');
end

