function exposurestep = calculate_exposuretime(number_photons,pixel_area,E,lambda)
%nach EMVA 1288 Release 3.1 Formel (4) S.5
%E in uW/cm^2, lambda in um, pixel_area in um^2
%Ausgabe in ms
exposurestep = number_photons/(50.34*pixel_area*E*lambda);
end

