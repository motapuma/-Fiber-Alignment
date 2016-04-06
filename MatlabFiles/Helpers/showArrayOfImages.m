function [ output_args ] = showArrayOfImages( images, titleL,offset )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

   nEle = numel(images);
   
   [m,n] = m_and_n_for_display( nEle );
   
   f=figure;
   if exist('titleL','var')
       set(f,'name',strcat('Fig ',titleL))
   end

   
   for index = 1:nEle
       subplot(m,n,index);
       subimage(images{index});
   end
   
end

