function [ imageNames ] = openImages( robin1_daniel0,limited,offsetImage )
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
    offset =0;
     if limited >= 0
        nFiles = limited;
        if isnumeric(offsetImage) && nFiles+offsetImage <= numel(files) && offsetImage > 0
            offset = offsetImage;
        end
     else
         nFiles = numel(files); 
         
     end
    
    arrayOfImages = cell(1,nFiles);
    
     for k=1:nFiles
        
       arrayOfImages{k}=imread(strcat(dirText, files{k+offset}));
       
       [a,b,c]=size(arrayOfImages{k});
       if c == 3
           arrayOfImages{k} = rgb2gray(arrayOfImages{k});
       end
       
       
     end
     
     imageNames = arrayOfImages;

end

