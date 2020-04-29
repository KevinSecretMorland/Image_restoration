function [kernel] = Gaussian_kernel(I,curve_size)

% [m,n] = size(I)
% 
sigma = curve_size/2;
% % % 
% % % sigma = 50
% curve_size = 10
mean = curve_size;
for i = 1 : curve_size
    for j = 1 : curve_size
    kernel(i,j) = (1/(sigma*(sqrt(2*pi))))*(exp(-(1/2)*((i+j-curve_size)/sigma)^2));
    kernel(i,j) = dot(kernel(i,j),kernel(i,j).');
    kernel(i,j) = sum(kernel(i,j));

    end
end
figure
surf(kernel);

% kernel = fspecial('gaussian', curve_size, sigma);

figure
plot(kernel)

end