function [ imagesRotated ] = rotateImages( array_of_images )
%ROTATEIMAGES Summary of this function goes here
%   Detailed explanation goes here

    nElements = numel(array_of_images);
    imagesRotated = cell(1,nElements);
    
    % CREATE THE FFT AND PLOT IT!!
    for index = 1:nElements
        
        img   = array_of_images{index};
        imagesRotated{index} = rot90(img,1);
        
    end
    
end

