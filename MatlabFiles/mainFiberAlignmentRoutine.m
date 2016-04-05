close all;
clear all;
robin1_daniel0 = 1; %To use Robin's Photos set to 1

if exist('arrayOfImages','var') == 0
    disp('Opening Images')
    arrayOfImages = openImages(robin1_daniel0);
    
end

if numel(arrayOfImages) == 0
   disp('ZERO Images')     
   return
end
    
showArrayOfImages(arrayOfImages);

if exist('fouriers','var') == 0
    fouriers = createFFT(arrayOfImages);
end
showArrayOfImages(fouriers);

if exist('fouriersFiltered','var') == 0
    fouriersFiltered = filterFourier( fouriers );
end

showArrayOfImages(fouriersFiltered);

% figure;
% se = strel('disk',3);
% fouriersFiltered = cell(1,nFiles);
% for index = 1:toshow
%      imageNumber = index*3;
%      img   = fouriers{index};
%      %img = imerode(img,se);
%      fouriersFiltered{index} = img;
%      subplot(m,n,index)
%      subimage(fouriersFiltered{index})
%      title(strcat('Image', num2str(imageNumber)))
% end
% 
% orientationFFTArr = cell(1,toshow);
% figure;
% for index = 1:toshow
%     img   = fouriersFiltered{index};
%     [newImg, arrRes]= addGradeLines( img, degreeSeparation );
%     orientationFFTArr{index} = arrRes;
%     subplot(m,n,index)
%     imshow(newImg)
% end
% 
% figure;
% meansAndSTDAndMax = cell(1,numel(orientationFFTArr));
% oriImgArr = cell(1,numel(orientationFFTArr));
% 
% for index = 1:numel(orientationFFTArr)
%     orArr  = orientationFFTArr{index};
%     
%     %Swapt to go from 0 to 180
%     middle = floor(numel(orArr)/2);
%     imgArr = horzcat(orArr(middle+1:end),orArr(1:middle));
%     %END swap to go from 0 to 180
%     
%     % Little filter
%     imgArr = smooth(imgArr,9);
%     oriImgArr{index} = imgArr;
%     
%     % Statistical Analysis
%     [maxValue,maxIndex]= max(imgArr);
%     meanImg = mean(imgArr);
%     stdImg  = std(imgArr);
%    
%     meansAndSTDAndMax{index}= [meanImg,stdImg,maxValue];
%     
%      %%%%%%%%%%%%%%%%%%%
%      %
%      % MUCHO POSIBLE ANALIS WIHT FINDPEAK in 2015
%      %
%      %%%%%%%%%%%%%%%%%%
%      
%     % Ploting
%     subplot(m,n,index)
%     x = linspace(0,180,numel(imgArr));
%     plot(x,imgArr)
%     areaBelowTheCurve = trapz(x,imgArr);
%     
%     
%     
%     %[pks,locs]=findpeaks(data,'minpeakdistance',3);
%     %min(imgArr);
%     minVal = min(imgArr);
%     middle = ((maxValue - minVal)/2) + minVal;
%     
%     %[sp, areaMax] = areaBelowaPeak(imgArr,x, maxIndex, meanImg/maxValue, 0.01);
%     [sp, areaMax,limits] = areaBelowaPeak(imgArr,x, maxIndex, middle/maxValue, 0.01);
%     %[sp, areaMax] = areaBelowaPeak(imgArr,x, maxIndex, 0.5, 0.01);
%     
%     if areaMax ==-1
%         areaMax = areaBelowTheCurve;
%         sp = 1;
%         %sp = numel(xArr)
%     end
%     ratio = areaMax/areaBelowTheCurve;
%     potencyDens =  ratio/sp;
%     
%     %if meanImg+2*stdImg < maxValue
%         l1 =strcat('Max Ori. ', num2str(maxIndex*degreeSeparation),'deg.');
%         l2 = strcat('Pot: ',num2str(ratio),'. Dens:',num2str(potencyDens));
%         l3 = strcat('Left: ',num2str(limits(1)),'. Rigth:',num2str(limits(2)));
%         title(strvcat(l1,l2,l3));
%     %else
%         %title(strvcat('NO ORi. ', num2str(maxIndex*degreeSeparation),'deg. Rat:',num2str(ratio),'.\\',num2str(potencyDens)))
%     %end
%     
%     hold on
%     plot(linspace(0,180,numel(imgArr)),ones(1,numel(imgArr))*meanImg,'g')
%     plot(linspace(0,180,numel(imgArr)),ones(1,numel(imgArr))*middle,'b')
%     plot(linspace(90,90,numel(imgArr)),linspace(meanImg-stdImg/2,meanImg+stdImg/2,numel(imgArr)),'r')
%     hold off
%     
% end
% 
% 
% %Show ORIGINAL PICTURES
% figure;
% for index = 1:toshow
%     imageNumber = index*3;
%     %img   = arrayOfImages{index*3};
%     img   = arrayOfImages{index};
%     subplot(m,n,index)
%     subimage(img)
%     title(strcat('Image ', num2str(imageNumber)))
% end
% % 
% % figure;
% % for index = 1:toshow
% %     img   = fouriers{index};
% %     [newImg, arrRes] = addGradeLines( img, 36 );
% %     subplot(m,n,index)
% %     imshow(newImg,[24 100000]), colormap(hot)
% %     title(strcat('Image', num2str(imageNumber)))
% % end
% 
