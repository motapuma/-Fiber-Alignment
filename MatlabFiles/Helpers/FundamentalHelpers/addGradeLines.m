function [ newImg,arrRes ] = addGradeLines( img, grades )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    
    %gradesSeparation = grades
    newImg = img;
    %newImg = zeros(size(img));
    [height, width] = size(img);
    height = height-1;
    width  = width -1;
    middleWidth  = round(width/2); 
    middleHeight = round(height/2);
    
    %for i = 10:gradesSeparation:30 
     %for i = 1:3:179 
     %for i =  85:3:179 
     step = grades;
     %iArr = 0:step:180;
     iArr = 0:step:90;
     arrRes = zeros(1,numel(iArr));
     j=1;
     
     for i =  iArr     
        tan = tand(i)*-1;
        
        if tan == -Inf
            newImg(1:middleHeight,middleWidth:middleWidth+1) = 33;
            toSum = img(1:middleHeight,middleWidth);
%             for j= 1:numel(toSum)
%                 toSum(j) = toSum(j)+(numel(toSum)-j)/724;
%             end
            %arrRes(j) = sum(toSum);
            arrRes(j) = sum(toSum)/numel(toSum);
        else
            %disp(i);
            
            if(i > 90)
                x = linspace(1,middleWidth,100000);
            else
                x = linspace(middleWidth,width,100000);
            end
            
            y = tan*x + (middleHeight-tan*middleWidth);

            rx = round(x);
            ry = round(y);
           % rx = rx(1:200);
           % ry = ry(1:200);
           %quito a los que se salen
            if(any( ry(:) <= 0 ) )
                ind = find(ry<1,1);
                if(ind <2)
                    ind = find(ry>1,1);
                    rx= rx(ind:numel(rx));
                    ry= ry(ind:numel(ry));
                else
                    rx= rx(1:ind-1);
                    ry= ry(1:ind-1);
                end
                
            end

%             for j= 1:numel(ry)
%                 img(ry(j),rx(j)) = img(ry(j),rx(j)) * distanceBetweenCoordinates(ry(j),rx(j),middleHeight,middleWidth)/724;
%             end
            
            index = sub2ind(size(img),ry,rx);
            newImg(index)   = 255;
            %newImg(index+1) = 255;
            toSum = img(index);
            %arrRes(j)   = sum(toSum);
            arrRes(j)   = sum(toSum)/numel(toSum);
            
        end
        j = j+1;
    end
    

end

