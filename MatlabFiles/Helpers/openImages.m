function [ imageNames ] = openImages( robin1_daniel0 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %root = FiberAlignmentConstants.root;
    root = 'G:\Desktop\QMUL\Disertation\MatlabSoftware\V1\MatlabFiberAlignment\FiberImages';
    if robin1_daniel0 == 1
        %Robins Images
        dirText = strcat(root,'/RobinImages/oneEachGroup/'); 
    elseif robin1_daniel0 == 0
        %Daniel Images
        dirText = strcat(root,'/DanielRowsonImages/');
    else
        disp('Set a correct value to choose the file');
        imageNames = {};
        return;
    end

    f = dir(strcat(dirText,'*.tif'));

    files ={f.name};
    nFiles = numel(files);
    arrayOfImages = cell(1,nFiles);

     for k=1:nFiles
       arrayOfImages{k}=imread(strcat(dirText, files{k}));
     end
     
     imageNames = arrayOfImages;

end

