function [ meansAndSTDAndMaxAndMin ] = getMeanStdAndMaxs( arrayOfResultsForEach,degreeSeparation )
%GETMEANSTDANDMAXS Summary of this function goes here
%   Detailed explanation goes here
    figure
    nEle = numel(arrayOfResultsForEach);
    meansAndSTDAndMaxAndMin = cell(1,nEle);
    oriImgArr = cell(1,nEle);
    [m,n] = m_and_n_for_display( nEle );
    for index = 1:nEle
        resultsForCase  = arrayOfResultsForEach{index};
        
        %Swapt to go from 0 to 180
        %middle = floor(numel(resultsForCase)/2);
        %imgArr = horzcat(resultsForCase(middle+1:end),resultsForCase(1:middle));
        %END swap to go from 0 to 180

        % Little filter
        resultsSmooth = smooth(resultsForCase,9);
        oriImgArr{index} = resultsSmooth;

        % Statistical Analysis
        [maxValue,maxIndex]= max(resultsSmooth);
        meanImg = mean(resultsSmooth);
        stdImg  = std(resultsSmooth);
        minVal = min(resultsSmooth);

        meansAndSTDAndMaxAndMin{index}= [meanImg,stdImg,maxValue,minVal];

         %%%%%%%%%%%%%%%%%%%
         %
         % MUCHO POSIBLE ANALIS WIHT FINDPEAK in 2015
         %
         %%%%%%%%%%%%%%%%%%

        % Ploting FIRST
        subplot(m,n,index)
        nEleResultsSmooth =numel(resultsSmooth);
        x = linspace(0,180,nEleResultsSmooth);
        plot(x,resultsSmooth)
        
        %EN PLOTTING FIRST

        totalAreaBelowTheCurve = trapz(x,resultsSmooth);
        middle = ((maxValue - minVal)/2) + minVal;

        [separationInXAxis, areaMax,limits] = areaBelowAPeak(resultsSmooth, x , maxIndex, middle/maxValue, 0.01);

        if areaMax ==-1
            areaMax = totalAreaBelowTheCurve;
            separationInXAxis = 1;
            disp('HERE WAS A MISTAKE')
        end

        ratio       = areaMax/totalAreaBelowTheCurve;
        potencyDens =  ratio/separationInXAxis;

        %if meanImg+2*stdImg < maxValue
            l1 = strcat('Max Ori. ', num2str(maxIndex*degreeSeparation),'deg.');
            l2 = strcat('Pot: ',num2str(ratio),'. Dens:',num2str(potencyDens));
            l3 = strcat('Left: ',num2str(limits(1)),'. Rigth:',num2str(limits(2)));
            title(strvcat(l1,l2,l3));
        %else
            %title(strvcat('NO ORi. ', num2str(maxIndex*degreeSeparation),'deg. Rat:',num2str(ratio),'.\\',num2str(potencyDens)))
        %end

        hold on
        plot(linspace(0,180,nEleResultsSmooth),ones(1,nEleResultsSmooth)*meanImg,'g')
        plot(linspace(0,180,nEleResultsSmooth),ones(1,nEleResultsSmooth)*middle,'b')
        plot(linspace(90,90,nEleResultsSmooth),linspace(meanImg-stdImg/2,meanImg+stdImg/2,numel(resultsSmooth)),'r')
        hold off

    end

end

