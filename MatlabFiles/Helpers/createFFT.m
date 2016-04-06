function [ fouriers ] = createFFT( array_of_images )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    nElements = numel(array_of_images);
    fouriers = cell(1,nElements);

    
    % CREATE THE FFT AND PLOT IT!!
    for index = 1:nElements
        
        img   = array_of_images{index};
        F = fft2(img);
        
        fouriers{index} = abs(fftshift(F));
        fouriers{index} = mat2gray(fouriers{index})*255;
    end
    
    

end

