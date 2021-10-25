function output = highpass_C5(img)
%Hochpass-Filter nach EMVA 1288 Release 3.1 S.37, Anhang C.5
filter_matrix=1/25*ones(5);
[M,N]=size(img);

matrix_img_conv=conv2(filter_matrix,img);

%zuschneiden
matrix_img_conv=matrix_img_conv(5:M,5:N);

output=img(3:M-2,3:N-2)-matrix_img_conv;
end

