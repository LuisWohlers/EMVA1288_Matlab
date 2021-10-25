function sigma_d = compute_temporaldarknoise(var_dark,var_quantisation,K)
%nach EMVA 1288 Release 3.1 S.17 Formel (31)
sigma_d=sqrt(var_dark-var_quantisation)/K;
end

