function output = absolute_sensitivity_threshold(quantum_efficiency,var_dark,K)
%nach EMVA 1288 Release 3.1 S.8 Formel (17)
output=1/quantum_efficiency*(sqrt(var_dark)/K+1/2);
end

