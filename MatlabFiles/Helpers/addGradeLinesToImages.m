function [ imagesObtained, resultFromArrayWithSumOfPixelsAtEachDegree ] = addGradeLinesToImages( images,degreeSeparation )
%ADDGRADELINES Summary of this function goes here
%   Detailed explanation goes here

     nEle              = numel(images);
     imagesObtained = cell(1,nEle);
     resultFromArrayWithSumOfPixelsAtEachDegree = cell(1,nEle);

     for index = 1:nEle
        [newImg, arrayWithSumOfPixelsAtEachDegree] = addGradeLines( images{index}, degreeSeparation);
        imagesObtained{index} = newImg;
        resultFromArrayWithSumOfPixelsAtEachDegree{index} = arrayWithSumOfPixelsAtEachDegree;
     end

end

