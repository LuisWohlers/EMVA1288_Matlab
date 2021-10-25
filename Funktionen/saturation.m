function [mgv_sat,var_sat] = saturation(mgv,vars)
%nach EMVA 1288 Relase 3.1 S.16 Abschnitt "Saturation"
%mgv:mean gray value array
%vars:variance array

var_lastidx=length(vars);

for idx=var_lastidx:-1:3
    if vars(idx)<0
        continue;
    elseif vars(idx-1) < vars(idx) && vars(idx-2) < vars(idx)
        idx_max=idx;
        break;
    end
end

mgv_sat=mgv(idx_max);
var_sat=vars(idx_max);
end

