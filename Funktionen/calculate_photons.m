function number_photons = calculate_photons(pixel_area,E,t_exp,lambda)
%nach EMVA 1288 Release 3.1 Formel (4) S.5
%Pixelfläche (pixel_area) in um^2, E in uW/cm^2, lambda in um und t_exp
%in ms
number_photons = 50.34*pixel_area*t_exp*lambda*E;
end

