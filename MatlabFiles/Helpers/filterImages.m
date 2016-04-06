function [ filteredImages ] = filterImages( array_of_images )
%FILTERIMAGES Summary of this function goes here
%   Detailed explanation goes here

    
    nElements = numel(array_of_images);
    filteredImages = cell(1,nElements);

    
    % CREATE THE FFT AND PLOT IT!!
    for index = 1:nElements
        
        img   = array_of_images{index};
        H = fspecial('average',100);
        
        filteredImages{index} = imfilter(img,H);
        
    end
end

