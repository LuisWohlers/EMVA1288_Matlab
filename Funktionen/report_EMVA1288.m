function report_EMVA1288(EMVA)

import mlreportgen.dom.*;
D=Document(EMVA.reportoutput_name,'docx',EMVA.reporttemplate_name);
open(D);
docHeaders = D.CurrentDOCXSection.PageHeaders;
docFooters = D.CurrentDOCXSection.PageFooters;
docHead1=docHeaders(1);
docFoot1=docFooters(1);

docHead1.moveToNextHole;
append(docHead1,EMVA.cameraname);

docFoot1.moveToNextHole;
append(docFoot1,datestr(datetime));

figHeight="11.11cm";
figWidth="14.28cm";

while ~strcmp(D.CurrentHoleId,'#end#')
    switch D.CurrentHoleId
        case "vendor"
            append(D,EMVA.vendor);
        case "model"
            append(D,EMVA.model);
        case "data type"
            append(D,EMVA.datatype);
        case "sensor type"
            append(D,EMVA.sensortype);
        case "diagonal"
            append(D,EMVA.diagonal);
        case "lens category"
            append(D,EMVA.lenscategory);
        case "resolution"
            append(D,EMVA.resolution);
        case "pixel size"
            append(D,EMVA.pixelsize);
        case "maximum readout rate"
            append(D,EMVA.maximumreadoutrate);
        case "dark current compensation"
            append(D,EMVA.darkcurrentcompensation);
        case "interface type"
            append(D,EMVA.interfacetype);
        case "light source"
            append(D,EMVA.lightsource);
        case "light source non uniformity"
            append(D,EMVA.lightsourcenonuniformity);
        case "irradiation calibration accuracy"
            append(D,EMVA.irradiationcalibrationaccuracy);
        case "standard version"
            append(D,EMVA.standardversion);
        case {"gain","gain op1"}
            append(D,sprintf('%0.0f',EMVA.gain));
        case {"black level","black level op1"}
            append(D,sprintf('%0.0f',EMVA.blacklevel));
        case {"bit depth","bit depth op1"}
            append(D,EMVA.bitdepth);
        case {"illumination","illumination op1"}
            append(D,Text(EMVA.illumination));
        case {"irradiation steps","irradiation steps op1"}
            append(D,EMVA.irradiationsteps);
        case {"op_point","op_point op1"}
            append(D,EMVA.operationpoint);
        case {"wavelength","wavelength op1"}
            append(D,sprintf('%0.0f',EMVA.lambda_um*1000));
        case "quantum efficiency"
            append(D,sprintf("%0.2f",EMVA.quantum_efficiency*100));
        case "K"
            append(D,sprintf("%0.2f",EMVA.K));
        case "1/K"
            append(D,sprintf("%0.4f",1/EMVA.K));
        case "sigma_d"
            append(D,sprintf("%0.3f",EMVA.temporal_dark_noise_e));
        case "sigma_y.dark"
            append(D,sprintf("%0.3f",sqrt(EMVA.var_dark_0)));
        case "SNR_max"
            append(D,sprintf("%0.2f",EMVA.SNR_max));
        case "SNR_max dB"
            append(D,sprintf("%0.2f",20*log10(EMVA.SNR_max)));
        case "SNR_max bit"
            append(D,sprintf("%0.1f",log2(EMVA.SNR_max)));
        case "SNR_max_-1 percent"
            append(D,sprintf("%0.3f",1/EMVA.SNR_max*100));
        case "mu_p.min"
            append(D,sprintf("%0.3f",EMVA.p_min));
        case "mu_e.min"
            append(D,sprintf("%0.3f",EMVA.p_min*EMVA.quantum_efficiency));
        case "mu_p.sat"
            append(D,sprintf("%0.0f",EMVA.p_sat));
        case "mu_e.sat"
            append(D,sprintf("%0.0f",EMVA.p_sat*EMVA.quantum_efficiency));
        case "DR"
            append(D,sprintf("%0.0f",EMVA.DR));
        case "DR dB"
            append(D,sprintf("%0.1f",20*log10(EMVA.DR)));
        case "DR bit"
            append(D,sprintf("%0.1f",log2(EMVA.DR)));
        case "DSNU e"
            append(D,sprintf("%0.1f",EMVA.DSNU));
        case "DSNU DN"
            append(D,sprintf("%0.1f",EMVA.DSNU*EMVA.K));
        case "PRNU percent"
            append(D,sprintf("%0.1f",EMVA.PRNU));
        case "LE_min"
            append(D,sprintf("%0.3f",EMVA.LE_min));
        case "LE_max"
            append(D,sprintf("%0.3f",EMVA.LE_max));
        case "mu_I.mean DN/s"
            append(D,sprintf("%0.3f",EMVA.I_mean_DN));
        case "mu_I.var DN/s"
            append(D,sprintf("%0.3f",EMVA.I_var_DN));
        case "mu_I.mean e/s"
            append(D,sprintf("%0.3f",EMVA.I_mean_e));
        case "mu_I.var e/s"
            append(D,sprintf("%0.3f",EMVA.I_var_e));
        case "photon transfer"
            saveas(EMVA.PhotonTransferFigure,'photontransfer.svg');
            plot=Image('photontransfer.svg');
            plot.Height=figHeight;
            plot.Width=figWidth;
            append(D,plot);
        case "signal-to-noise ratio"
            saveas(EMVA.SNRFigure,'snr.svg');
            plot2=Image('snr.svg');
            plot2.Height=figHeight;
            plot2.Width=figWidth;
            append(D,plot2);
        case "sensitivity"
            saveas(EMVA.SensitivityFigure,'sensitivity.svg');
            plot3=Image('sensitivity.svg');
            plot3.Height=figHeight;
            plot3.Width=figWidth;
            append(D,plot3);
        case "linearity"
            saveas(EMVA.LinearityFigure,'linearity.svg');
            plot4=Image('linearity.svg');
            plot4.Height=figHeight;
            plot4.Width=figWidth;
            append(D,plot4);
        case "deviation linearity"
            saveas(EMVA.DeviationLinearityFigure,'deviationlinearity.svg')
            plot5=Image('deviationlinearity.svg');
            plot5.Height=figHeight;
            plot5.Width=figWidth;
            append(D,plot5);
        case "horizontal spectrogram prnu"
            saveas(EMVA.spectrogram_horizontal_PRNU_Figure,'spectrhorizPRNU.svg');
            plot6=Image('spectrhorizPRNU.svg');
            plot6.Height=figHeight;
            plot6.Width=figWidth;
            append(D,plot6);
        case "horizontal spectrogram dsnu"
            saveas(EMVA.spectrogram_horizontal_DSNU_Figure,'spectrhorizDSNU.svg');
            plot7=Image('spectrhorizDSNU.svg');
            plot7.Height=figHeight;
            plot7.Width=figWidth;
            append(D,plot7);
        case "vertical spectrogram prnu"
            saveas(EMVA.spectrogram_vertical_PRNU_Figure,'spectrvertPRNU.svg');
            plot8=Image('spectrvertPRNU.svg');
            plot8.Height=figHeight;
            plot8.Width=figWidth;
            append(D,plot8);
        case "vertical spectrogram dsnu"
            saveas(EMVA.spectrogram_vertical_DSNU_Figure,'spectrvertDSNU.svg');
            plot9=Image('spectrvertDSNU.svg');
            plot9.Height=figHeight;
            plot9.Width=figWidth;
            append(D,plot9);
        case "log hist dsnu"
            saveas(EMVA.log_hist_DSNU_Figure,'loghistDSNU.svg');
            plot10=Image('loghistDSNU.svg');
            plot10.Height=figHeight;
            plot10.Width=figWidth;
            append(D,plot10);
        case "log hist prnu"
            saveas(EMVA.log_hist_PRNU_Figure,'loghistPRNU.svg');
            plot11=Image('loghistPRNU.svg');
            plot11.Height=figHeight;
            plot11.Width=figWidth;
            append(D,plot11);
        case "acc log hist dsnu"
            saveas(EMVA.acc_log_hist_DSNU_Figure,'acclogDSNU.svg');
            plot12=Image('acclogDSNU.svg');
            plot12.Height=figHeight;
            plot12.Width=figWidth;
            append(D,plot12);
        case "acc log hist prnu"
            saveas(EMVA.acc_log_hist_PRNU_Figure,'acclogPRNU.svg');
            plot13=Image('acclogPRNU.svg');
            plot13.Height=figHeight;
            plot13.Width=figWidth;
            append(D,plot13);
        case "horizontal profiles"
            saveas(EMVA.HorizontalProfilesFigure,'horizontalprofiles.svg');
            plot14=Image('horizontalprofiles.svg');
            plot14.Height=figHeight;
            plot14.Width=figWidth;
            append(D,plot14);
        case "vertical profiles"
            saveas(EMVA.VerticalProfilesFigure,'verticalprofiles.svg');
            plot15=Image('verticalprofiles.svg');
            plot15.Height=figHeight;
            plot15.Width=figWidth;
            append(D,plot15);
        case "dark current from mean"
            saveas(EMVA.dCmeanFigure,'darkCurrent_mean.svg');
            plot16=Image('darkCurrent_mean.svg');
            plot16.Height=figHeight;
            plot16.Width=figWidth;
            append(D,plot16);
        case "dark current from variance"
            saveas(EMVA.dCvarFigure,'darkCurrent_var.svg');
            plot17=Image('darkCurrent_var.svg');
            plot17.Height=figHeight;
            plot17.Width=figWidth;
            append(D,plot17);
    end
    moveToNextHole(D);
end

close(D)
delete darkCurrent_mean.svg;
delete darkCurrent_var.svg;
delete verticalprofiles.svg;
delete horizontalprofiles.svg;
delete acclogDSNU.svg;
delete acclogPRNU.svg;
delete loghistDSNU.svg;
delete loghistPRNU.svg;
delete spectrvertDSNU.svg;
delete spectrvertPRNU.svg;
delete deviationlinearity.svg;
delete spectrhorizDSNU.svg;
delete spectrhorizPRNU.svg;
delete linearity.svg;
delete sensitivity.svg;
delete photontransfer.svg;
delete snr.svg;
end

