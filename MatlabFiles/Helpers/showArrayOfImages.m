function [ output_args ] = showArrayOfImages( images )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

   nEle = numel(images);
   
    switch nEle
        case 9
            m=3;
            n=3;
        case 4
            m=2;
            n=2;
        case 6
            m=3;
            n=2;
        otherwise
            m=ceil(nEle/2);
            n=2;
    end
   
   figure 
   for index = 1:nEle
       subplot(m,n,index);
       subimage(images{index})
   end
   
end

