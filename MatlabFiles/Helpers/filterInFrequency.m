function [ filteredInFreq ] = filterInFrequency( array_of_images,array_of_filter )
%FILTERINFREQUENCY Summary of this function goes here
%   Detailed explanation goes here
    
    nElements      = numel(array_of_images);
    filteredInFreq = cell(1,nElements);

    
    % CREATE THE FFT AND PLOT IT!!
    for index = 1:nElements
        
        img    = array_of_images{index};
        filter = array_of_filter{index};
        
        indexes = find(filter >= 0.1);
        img(indexes) = 0;
        filteredInFreq{index} = img;
    end

end

