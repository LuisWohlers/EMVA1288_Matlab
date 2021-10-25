function output = stack_variance_3dmat(input)
%nach EMVA 1288 Release 3.1 S.22 Formel (44)
%input: MxNxL-Matrix

[M,N,L]=size(input); 

input=double(input);

%Linker Teil der Formel

%1/L mal die Summen über y[l][m][n] (von l=0 bis l=L-1 bzw. enstprechenden 
%Indizes (rechter Teil der linken Gleichung)
subtracted_sum=1/L.*sum(input,3);

%Subtraktion y[l][m][n]-subtracted_sum und Quadrierung
inner=(input-subtracted_sum).^2;

%Summe über obiges Ergebnis von l
var_s_m_n=1/(L-1).*sum(inner,3);


%Rechter Teil der Formel
output=1/(M*N).*sum(var_s_m_n(:));

end

