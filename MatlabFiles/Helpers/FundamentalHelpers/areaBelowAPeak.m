function [ sp, area,limits ] = areaBelowAPeak( xArr,lineSpace, maxIndex, proportion, tolerance)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    

    %%%%%%%%%
    %
    % CONCATENAALOOOOSSS y asi si puedesmedir un poco mas
    %
    %%%%%
    leftArr  = xArr(1:maxIndex);
    rigthArr = xArr(maxIndex:end);
    
    toFind   = xArr(maxIndex)* proportion;
    
    %rigthLimitA = find(abs(rigthArr-toFind)<tolerance,1);
    %leftLimitA = find(abs(leftArr-toFind)<tolerance,1,'last');
    rigthLimitA = find((rigthArr<toFind),1);
    leftLimitA = find((leftArr<toFind),1,'last');
    
    noEnoughRigth = 0;
    noEnoughleft = 0;
    
    if(numel(rigthLimitA)< 1 )
        rigthLimitA(1) = numel(rigthArr)-1;
        noEnoughRigth=1;
    end
    
    if(numel(leftLimitA)<1)
       leftLimitA(1) = 1;
       noEnoughleft = 1;
    end
    
    rigthLimitIndex = rigthLimitA(1) + maxIndex-1;
    leftLimitIndex  = leftLimitA(1);
    
    if rigthLimitIndex == leftLimitIndex
        
        if  leftLimitIndex ~= 0
            leftLimitIndex= leftLimitIndex-1;
        else
            rigthLimitIndex = leftLimitIndex+1;
        end
        
    end
    
    limits(1) = leftLimitIndex;
    limits(2) = rigthLimitIndex;
    
    sp = abs(rigthLimitIndex-leftLimitIndex);
    
    area = trapz(lineSpace(leftLimitIndex:rigthLimitIndex),xArr(leftLimitIndex:rigthLimitIndex));

    
    % look to the other side when not found
    
    if(noEnoughRigth >0)
        
        newLeftIndexArr = find(abs(leftArr-toFind)<tolerance,1);
        
        if(numel(newLeftIndexArr))
            newLeftIndex = newLeftIndexArr(1);
            limits(1) = newLeftIndex;
            
            if newLeftIndex <= 1
                %If it is realy in the left side...Everything must remain
                %the same
                
            else
                nA = trapz(lineSpace(1:newLeftIndex),xArr(1:newLeftIndex));
                sp = sp + newLeftIndex;
                area = area + nA;
            end
            
        else
            area =-1;
            disp('ERRROOOORRR riogth');
        end
        
    end
    
    if(noEnoughleft >0)
        
        newRigthIndexArr = find(abs(rigthArr-toFind)<tolerance,1,'last');
        
        if(numel(newRigthIndexArr))
            newRigthIndex = newRigthIndexArr(1);
            limits(2) = newRigthIndex;
            if abs(newRigthIndex-numel(xArr))<=1
                %If it is realy in the rigth side...Everything must remain
                %the same
                
            else
                nA = trapz(lineSpace(newRigthIndex:end),xArr(newRigthIndex:end));
                sp = sp + numel(rigthArr)-newRigthIndex;
                area = area + nA;
                
            end
            
            
        else
            area =-1;
            disp('ERRROOOORRR left');
        end
        
    end
    
    step      = 180/numel(xArr); 
    limits(1) = limits(1)*step;
    limits(2) = limits(2)*step;
    
    sp = sp/numel(xArr);%width normalized DESCOMENT SI TODO DEJA DE
    %FUNCIONAR
    

end

