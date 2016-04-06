function [ filteredImages ] = highFrequencyFilter( array_of_images )
%HIGHFREQUENCYFILTER Summary of this function goes here
%   Detailed explanation goes here


    nElements = numel(array_of_images);
    filteredImages = cell(1,nElements);

    
    % CREATE THE FFT AND PLOT IT!!
    for index = 1:nElements
        
        img   = array_of_images{index};
        
        [a,b] = size(img);
        
        middleWidth  = round(b/2);
        middleHeight = round(a/2);
        
        oneForthWidth  = middleWidth/4;% in reality is 1/8
        oneForthHeight = middleHeight/4;% in reality is 1/8
        
        for i = 1:a
            for j = 1:b
                
                if( i<middleHeight-oneForthHeight || j<middleWidth-oneForthWidth || j>middleWidth+oneForthWidth || i > middleHeight + oneForthHeight )
                    img(i,j)= 0;
                end
                
            end
        end
        filteredImages{index}= img;
        

    end


end

