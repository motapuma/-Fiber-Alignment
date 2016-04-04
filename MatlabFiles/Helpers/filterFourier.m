function [ fouriersFiltered ] = filterFourier( fouriers )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    nFiles = numel(fouriers);
    se = strel('disk',3);
    fouriersFiltered = cell(1,nFiles);
    
    parfor index = 1:nFiles
         img = imerode(fouriers{index},se);
         fouriersFiltered{index} = imerode(img,se);
    end

end

