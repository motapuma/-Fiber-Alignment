function [ output_args ] = showArrayOfImages( images )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

   nEle = numel(images);
   
    [m,n] = m_and_n_for_display( nEle );
   
   figure 
   for index = 1:nEle
       subplot(m,n,index);
       subimage(images{index})
   end
   
end

