clear all
close all

I = imread('test_train_1.jpg');
I = rgb2gray(I);
I_normal = I;

[m,n] = size(I);
% I = imnoise(I,'gaussian');
I_filtered = I;

% motion = fspecial('gaussian',40,10);
% I = imfilter(I,motion,'replicate');

%I noised in frequency domaine
work = I;
work = fft2(work);
fft_work = work;

%Point-Spread function
the_kernel = Gaussian_kernel(I,6);
the_kernel = fft2(the_kernel,m,n);
PS = the_kernel;


%Inverse function
N = fspecial('gaussian',m,5);
N = fft2(N,m,n);
Inverse = the_kernel.*work + N;

%Wiener
K = 0.3;
Alpha = 0.01;
Wiener_calc = (((conj(the_kernel))./((abs(the_kernel).^2))).^Alpha).*((conj(the_kernel))./((abs(the_kernel).^2)+K)).^1-Alpha;

%Constraint Least Squares
Lambda = 0.2;
laplace = [0 -1 0;-1 4 -1;0 -1 0];
fft_laplace = fft2(laplace,m,n);
Constraint_Least_Square = (abs((conj(the_kernel))./ ((abs(the_kernel).^2) + Lambda.*(abs(fft_laplace).^2))));

%Computation of noised image and filter
Wiener_f = work.*Wiener_calc;
Wiener_f = abs(ifft2(Wiener_f));

CLSF = work.*Constraint_Least_Square;
CLSF= abs(ifft2(CLSF));


%Show result
figure
subplot(3,3,1)
imshow(I_normal,[])
title('Original image')
imwrite(I_normal,'normal.png');
subplot(3,3,2)
imshow(I_filtered,[])
title('Noised image')
imwrite(I_filtered,'I_filtered.png');
subplot(3,3,3)
imshow(log(abs(fftshift(fft_work))),[]);
title('Noised image spectrum')
subplot(3,3,4)
imshow(log(2+abs(fftshift(PS))),[]);
title('Point-spread')
subplot(3,3,5)
imshow(log(2+abs(fftshift(Wiener_calc))),[]);
title('Wiener')
subplot(3,3,6)
imshow(log(2+abs(fftshift(Constraint_Least_Square))),[]);
title('CLSF')
subplot(3,3,7)
imshow(abs(ifft2(Inverse)),[]);
title('Inverse Result')
imwrite(Inverse,'Inverse_result.png');
subplot(3,3,8)
imshow(Wiener_f,[])
title('Wiener Result')
imwrite(Wiener_f,'Wiener_result.png');
subplot(3,3,9)
imshow(CLSF,[])
imsave
title('CLSF Result')
imwrite(uint8(CLSF)-100,'CLSF_result.png');


