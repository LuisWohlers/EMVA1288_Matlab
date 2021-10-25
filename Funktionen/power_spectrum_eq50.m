function p = power_spectrum_eq50(y)
%Leistungsdichtespektrum nach Formel (50), S.22 EMVA 1288 Release 3.1
[M,V]=size(y);
p=1/M*sum(y(1:M,1:V).*conj(y(1:M,1:V)));
end

