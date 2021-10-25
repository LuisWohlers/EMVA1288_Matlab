classdef EMVA1288_mono < handle
%     für EMVA1288 Release 3.1 -konforme Charakterisierung
%     Messungen nach Messmethoden I und II (I: Variation der Strahlung der
%     Lichtquelle
%     oder II: Variation der Belichtungszeit)
%
%------------------------------------------------------------------------------
%     Benötigte Ordner mit Bilddateien (5 oder 6): 
%     
%   Erste Messreihen:
%     - Dunkelbilder, zwei pro Belichtungszeit
%                   -> Variante I: zwei Stück
%                   -> Variante II: Bei B Beleuchtungsstufen 2B Bilder
%                   jeweils zwei Bilder hintereinander zu einer Stufe
%                   (entsprechende Benennung der Bilder ist nötig, sonst
%                   entstehen falsche Ergebnisse)
%     
%     - Bilder bei verschiedener Bestrahlungsintensität des Sensors
%               ->jeweils zwei pro Stufe, also bei S Stufen insgesamt 2S
%               Bilder
%                   jeweils zwei Bilder hintereinander zu einer Stufe
%                   (entsprechende Benennung der Bilder ist nötig, sonst
%                   entstehen falsche Ergebnisse)
%
%     - Für Messvariante II zusätzlich: Aufnahmen bei miminaler
%     Belichtungszeit (siehe S.17,"For the measurement method II and III in Section 6.3 make an
%       extra measurement at a minimal exposure time to estimate
%       mu_y.dark")
%
%   Teil 2 der Messungen:   
%     -Zur Bestimmung des Dunkelstroms zusätzlich je ein Bild bei
%       mindestens 6 Belichtungsstufen, evtl. bei Variante I größere
%       Intervalle als in den Dunkelbildern zur Bestimmung der Photon
%       Transfer-Kurve, Empfindlichkeit und Linearitätseigenschaften
%           (siehe Abschnitt 7, S.20)
%       (evtl. lassen sich hier auch die Dunkelbilder aus Teil 1 verwenden,
%       falls die Belichtungszeiten nicht zu kurz sind)
%   
%
%   Teil 3 der Messungen: 
%      Die Ergebnisse der Messungen bei verschiedenen Photonen-Stufen
%      werden zur Bestimmung des Punktes benötigt, bei dem 50% der
%      Sättigung erreicht sind, dieser ist für die Berechnung der PRNU
%      von Bedeutung
%     - DSNU (Dark Signal NonUniformity): wenn möglich mindestens L=100 bis L=400 
%               Dunkelbilder zur
%               Messung räumlicher Ungleichmäßigkeiten, ebenso
%     
%     - PRNU (Photo Response NonUniformity): L Bilder bei 50% Sättigung
%     
%----------------------------------------------------------------------------------
%
%     Zu notierende Daten:
%           Kameradaten: Hersteller, Modell
%                       Datentyp, Sensortyp, Sensordiagonale, lens
%                       category, Auflösung, Pixelgröße
%                       -CCD: Readout type, transfer type
%                       -CMOS: Verschlusstyp (shutter type), overlap
%                       capabilities
%                       -Alle Typen: Maximum readout rate, dark current
%                       compensation (Ja/nein), Interface-Typ
%                       -Zum jeweiligen Arbeitspunkt (Operation Point):
%                           gain, offset, Bittiefe, Belichtungsstufen,
%                           genutzte Messung (Variation Belichtungszeit
%                           oder Lichtstärke), weitere Daten
%                       -Möglichst detaillierte Daten zur Lichtquelle
%                       bezüglich Ungleichmäßigkeiten, spektralen
%                       Eigenschaften etc.
%                       -Kalibrierungsdaten
%                   ---> siehe Abschnitt 10, Release 3.1
%     
%     Neben Bildern zu messende Daten (teilweise oben auch schon genannt):
%                   -Temperatur falls möglich
%                   -Ungleichmäßigkeiten der Bestrahlung (Formel (27))
    properties
        
%Aufnahmen---------------------------------------------------------

        image_width;
        image_height;
        %Ordner mit zwei oder 2L Dunkelbildern im Falle von L
        %Belichtungszeiten
        direction_dark_mv;%Adresse
        %dazugehörige MxNxL-Matrix 
        images_dark_mv;
        
        %Ordner mit je zwei Bildern pro Bestrahlungsstufe
        direction_mv;%Adresse
        %dazugehörige MxNxL-Matrix 
        images_mv;
        
        %Für Variante II eine zusätzliche Messung (Zwei Bilder)
        direction_minimal;
        images_minimal;
        
        
        %Ordner mit Bildern zur Berechnung des Dunkelstroms (dark current)
        %Bei mindestens 6 Belichtungsstufen mit gleichen abständen (siehe
        %Abschnitt 7.1, S.20)
        direction_dc;%Adresse
        %dazugehörige MxNxL-Matrix
        images_dc;
        
        %mindestens 100 Dunkelbilder für DSNU
        direction_dark_DSNU;%Adresse
        %dazugehörige MxNxL-Matrix
        images_dark_dsnu;
        
        %und bei 50% der Sättigung für PRNU-Berechnung
        direction_50_PRNU;%Adresse
        %dazugehörige MxNxL-Matrix
        images_50_prnu;
%------------------------------------------------------------------------

%Kameradaten und Messbedingungen-----------------------------------------
        cameraname="-";
        vendor="-";
        model="-";
        datatype="-";
        sensortype="-";
        diagonal="-";
        lenscategory="-";
        resolution="-";
        pixelsize="-";
        maximumreadoutrate="-";
        gain;
        blacklevel;
        bitdepth="-";
        darkcurrentcompensation="-";
        interfacetype="-";
        lightsource="-";
        lightsourcenonuniformity="-";
        irradiationcalibrationaccuracy="-";
        irradiationmeasurementerror="-";
        standardversion="3.1";
        illumination="-";
        irradiationsteps;
        
        offset;
        
        operationpoint="-";
        %wavelength;
%------------------------------------------------------------------------

        %-------------------nicht implementiert
%         mu_p_min_area="-";
%         mu_e_min_area="-";
%         mu_p_sat_area="-";
%         mu_e_sat_area="-";
        %-------------------
        
        deltaE_percent;
        photonsperstep;
        
        quantization_variance = 1/12;%in DN^2, siehe Abschnitt 2.2
        
        
        E; %für Messvariante I, in muW/cm^2
        t_exp_min; %für Messvariante I, in ms
        interval_exp;%für Messvariante I, in s
        pixel_area; %in um^2
        lambda_um; %in um
        
        mv_mean_dark;
        mv_var_dark;

%--------------------------------------------------------        
        K; %System gain
        PhotonTransferFigure;
        
        R; %Responsivity
        p_sat; %Photonen bei Sättigung
        e_sat; %saturation capacity
        p_min; %absolute sensitivity threshold
        SensitivityFigure;
        
        quantum_efficiency;
        
        LE_min;
        LE_max;
        LinearityFigure;
        DeviationLinearityFigure;
        
        var_dark_0;
        temporal_dark_noise_DN;
        temporal_dark_noise_e;
        
        %Dark current
        I_mean_DN;
        I_var_DN;
        I_mean_e;
        I_var_e;
        
        %für Aufnahmen bei 50% Sättigung (benötigt für PRNU) muss errechnet
        %werden
        E_t_exp_50_sat; % in ms*uW/cm^2
        t_exp_50_sat; %in us
        
        DR;%Dynamic Range
        SNR_max;
        SNRFigure;
        
        DSNU;
        PRNU;
        
        %nicht auf datasheet benötigt--
        sv_dark;
        sv_50;
        avg_img_dark;
        avg_img_50;
        var_stack_dark;
        var_stack_50;
        %------------------------------
        
        VerticalProfilesFigure;
        HorizontalProfilesFigure;
        
        log_hist_DSNU_Figure;
        log_hist_PRNU_Figure;
        L_DSNU;
        L_PRNU;
        
        acc_log_hist_DSNU_Figure;
        acc_log_hist_PRNU_Figure;
        
        spectrogram_vertical_DSNU_Figure;
        spectrogram_horizontal_DSNU_Figure;
        spectrogram_vertical_PRNU_Figure;
        spectrogram_horizontal_PRNU_Figure;
        
        dCmeanFigure;
        dCvarFigure;
        
%------------------------------------------------------------------------
        reporttemplate_name;
        reportoutput_name;
      
    end
    
    methods
        
%Inhalte der Ordner (Aufnahmen)in MxNxL-Matrizen---------------------------
% (Höhe x Breite x Anzahl der Aufnahmen)
        function measurements_mv_to3dMatrix(EMVA)
            %Erste Messreihen: Bilder bei verschiedenen Stufen sowie pro
            %Belichtungszeit Dunkelbilder
            EMVA.images_dark_mv=loadRAWin3dMatrix_mono(EMVA.direction_dark_mv,EMVA.image_width,EMVA.image_height);
            EMVA.images_mv=loadRAWin3dMatrix_mono(EMVA.direction_mv,EMVA.image_width,EMVA.image_height);
            
            [~,~,L]=size(EMVA.images_dark_mv);
            if(L==2)
                EMVA.images_minimal=loadRAWin3dMatrix_mono(EMVA.direction_minimal,EMVA.image_width,EMVA.image_height);
            end
        end
        
        function measurements_dc_to3dMatrix(EMVA)
            %Messreihen für dark current
            EMVA.images_dc=loadRAWin3dMatrix_mono(EMVA.direction_dc,EMVA.image_width,EMVA.image_height);
        end
        
        function measurements_dsnu_prnu_to3dMatrix(EMVA)
            %Messreihen für DSNU und PRNU
            EMVA.images_dark_dsnu=loadRAWin3dMatrix_mono(EMVA.direction_dark_DSNU,EMVA.image_width,EMVA.image_height);
            EMVA.images_50_prnu=loadRAWin3dMatrix_mono(EMVA.direction_50_PRNU,EMVA.image_width,EMVA.image_height);
        end
%--------------------------------------------------------------------------
        

        function calc_deltaE_percent(EMVA,Emin,Emax,E_avg)
            %deltaE nach Abschnitt 6.1 Formel (27)
            EMVA.deltaE_percent=(Emax-Emin)/E_avg*100;
        end
        
        function calc_photonsperstep(EMVA)
            EMVA.photonsperstep=calculate_photons(EMVA.pixel_area,EMVA.E,EMVA.t_exp_min,EMVA.lambda_um);
        end
        
        function evaluate_mv(EMVA)
            [~,~,L]=size(EMVA.images_dark_mv);
            if(L==2) %Variante II
                [EMVA.mv_mean_dark,EMVA.mv_var_dark,EMVA.var_dark_0]=dark_mean_var(EMVA.images_dark_mv,EMVA.images_minimal);
            else %Variante I
                [EMVA.mv_mean_dark,EMVA.mv_var_dark,EMVA.var_dark_0]=dark_mean_var(EMVA.images_dark_mv,EMVA.interval_exp);
            end
            
            [EMVA.K,EMVA.PhotonTransferFigure]=photonTransfer_curve(EMVA.images_mv,EMVA.mv_mean_dark,EMVA.mv_var_dark);
            
            [EMVA.R,EMVA.p_sat,EMVA.SensitivityFigure]=sensitivity_curve(EMVA.images_mv,EMVA.photonsperstep,EMVA.mv_mean_dark,EMVA.mv_var_dark);
            
            [EMVA.LE_min,EMVA.LE_max,EMVA.LinearityFigure,EMVA.DeviationLinearityFigure] = linearity_2(EMVA.images_mv,EMVA.photonsperstep,EMVA.mv_mean_dark,EMVA.mv_var_dark);
            
            EMVA.quantum_efficiency=EMVA.R/EMVA.K;
            
            EMVA.e_sat=EMVA.quantum_efficiency*EMVA.p_sat;
            
            EMVA.temporal_dark_noise_e=compute_temporaldarknoise(EMVA.var_dark_0,EMVA.quantization_variance,EMVA.K);
            
            EMVA.p_min=absolute_sensitivity_threshold(EMVA.quantum_efficiency,EMVA.var_dark_0,EMVA.K);
            
        end
        
        function evaluate_dc(EMVA)
            [EMVA.I_mean_DN,~,EMVA.dCmeanFigure]=darkCurrent_frommean(EMVA.images_dc,0.1);
            [EMVA.I_var_DN,~,EMVA.dCvarFigure]=darkCurrent_fromvariance(EMVA.images_dc,0.1,EMVA.temporal_dark_noise_e,EMVA.K);
            EMVA.I_var_e=EMVA.I_var_DN/EMVA.K^2;
            EMVA.I_mean_e=EMVA.I_mean_DN/EMVA.K;
        end
        
        function product_E_t_exp_50(EMVA)
            %für Aufnahmen bei 50% Sättigung (benötigt für PRNU) muss errechnet
            %werden, wie diese aufgenommen werden müssen
            %-> aus p_sat wird das Produkt E*t_exp ausgerechnet (Umstellung von
            %Formel (4))
            EMVA.E_t_exp_50_sat=EMVA.p_sat/2*1/(50.34*EMVA.pixel_area*EMVA.lambda_um);
        end
        
        function t_exp_50(EMVA)
            %für Aufnahmen bei 50% Sättigung (benötigt für PRNU) muss errechnet
            %werden, wie diese aufgenommen werden müssen
            %-> aus p_sat wird die Belichtungszeit bei 50% Sättigung
            %ausgerechnet (für Variante I)
            %in ms
            exp=EMVA.p_sat/2*1/(50.34*EMVA.pixel_area*EMVA.lambda_um*EMVA.E);
            %in us, gerundet
            EMVA.t_exp_50_sat=round(1000*exp);
        end
        
        function evaluate_dsnu_prnu(EMVA)
            [EMVA.DSNU,EMVA.PRNU,EMVA.sv_50,EMVA.sv_dark,EMVA.avg_img_dark,EMVA.avg_img_50,EMVA.var_stack_dark,EMVA.var_stack_50] = DSNU_PRNU(EMVA.images_dark_dsnu,EMVA.images_50_prnu,EMVA.K);
            
            [EMVA.SNR_max,EMVA.DR,EMVA.SNRFigure] = plot_SNR_2(EMVA.images_mv,EMVA.mv_mean_dark,EMVA.photonsperstep,EMVA.p_min,EMVA.p_sat,EMVA.e_sat,EMVA.temporal_dark_noise_e,EMVA.quantization_variance,EMVA.K,EMVA.quantum_efficiency,EMVA.DSNU,EMVA.PRNU);
            
            [EMVA.VerticalProfilesFigure,EMVA.HorizontalProfilesFigure]=profiles(EMVA.avg_img_dark,EMVA.avg_img_50);
            
            [~,EMVA.spectrogram_vertical_DSNU_Figure] = spectrogram(EMVA.avg_img_dark,EMVA.avg_img_50,'horizontal','DSNU',EMVA.DSNU,EMVA.var_stack_dark,EMVA.K);
            
            [~,EMVA.spectrogram_horizontal_DSNU_Figure] = spectrogram(EMVA.avg_img_dark,EMVA.avg_img_50,'vertical','DSNU',EMVA.DSNU,EMVA.var_stack_dark,EMVA.K);
            
            [~,EMVA.spectrogram_vertical_PRNU_Figure] = spectrogram(EMVA.avg_img_dark,EMVA.avg_img_50,'vertical','PRNU',EMVA.PRNU,EMVA.var_stack_50,EMVA.K);
            
            [~,EMVA.spectrogram_horizontal_PRNU_Figure] = spectrogram(EMVA.avg_img_dark,EMVA.avg_img_50,'horizontal','PRNU',EMVA.PRNU,EMVA.var_stack_50,EMVA.K);
            
            EMVA.log_hist_DSNU_Figure = logarithmic_histogram_DSNU(EMVA.avg_img_dark,EMVA.L_DSNU,EMVA.sv_dark);
            
            EMVA.log_hist_PRNU_Figure = logarithmic_histogram_PRNU(EMVA.avg_img_dark,EMVA.avg_img_50,EMVA.L_PRNU);
            
            EMVA.acc_log_hist_DSNU_Figure = accumulated_log_histogram_DSNU(EMVA.avg_img_dark,EMVA.L_DSNU);
            
            EMVA.acc_log_hist_PRNU_Figure = accumulated_log_histogram_PRNU(EMVA.avg_img_dark,EMVA.avg_img_50,EMVA.L_DSNU);
        end
        
        function report(EMVA)
            report_EMVA1288(EMVA);
        end
    end
end

