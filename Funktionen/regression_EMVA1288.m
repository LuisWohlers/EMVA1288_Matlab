function [a_0,a_1] = regression_EMVA1288(H,y)
%Berechnung von a_0 , a_1 und dafür auch delta
%der Funktionen (35), (36) und (37) 
%nach EMVA 1288 Release 3.1


%Aufsummierung von H(i)/y(i)^2
sum_hi_yi_sq=sum(H./(y.^2));

%Aufsummierung von H(i)/y(i)
sum_hi_yi=sum(H./y);

%Aufsummierung von H(i)^2/y(i)^2
sum_hi_sq_yi_sq=sum((H./y).^2);

%Aufsummierung von 1/y(i)^2
sum_1_yi_sq=sum(1./(y.^2));

%Aufsummierung von 1/y(i)
sum_1_yi=sum(1./y);

%Formel (37)
delta=sum_hi_yi_sq^2-sum_hi_sq_yi_sq*sum_1_yi_sq;

%Formel (35)
a_0=1/delta*(sum_hi_yi*sum_hi_yi_sq-sum_hi_sq_yi_sq*sum_1_yi);


%Formel (36)
a_1=1/delta*(sum_hi_yi_sq*sum_1_yi-sum_hi_yi*sum_1_yi_sq);

end

