function [ newImg,arrRes ] = addGradeLines( img, grades )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    

    newImg = img;

    [height, width] = size(img);
    height = height-1;
    width  = width -1;
    middleWidth  = round(width/2); 
    middleHeight = round(height/2);
    

     iArr = 0:grades:180;
     arrRes = zeros(1,numel(iArr));
     j=1;
     
     for i =  iArr     
         
        tan = tand(i)*-1;%the negative tangent of the degree
        
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
                x = linspace(1,middleWidth,100000);%creating the x-axis
            else
                x = linspace(middleWidth,width,100000);%creating the x-axis
            end
            
            %y = m*x+b //Why the tan is negative?
            % b = y-m*x
            % y= middle Height... x = middleWidth... m = tan
            y = tan*x + (middleHeight-tan*middleWidth);
            
            % y is now a big array

            rx = round(x);
            ry = round(y);
           % rx = rx(1:200);
           % ry = ry(1:200);
           
           %take out "y" smaller than 0
            if(any( ry(:) <= 0 ) )
                ind = find(ry<1,1);%search the fist y smaller than 1
                
                if(ind < 2)
                    ind = find(ry>1,1);%CUt in the rigth direction for the first positive to further 
                    rx= rx(ind:numel(rx));
                    ry= ry(ind:numel(ry));
                else
                    rx= rx(1:ind-1);%quit everything on the x out of the indexes greater than 1
                    ry= ry(1:ind-1);%quit everything on the y out of the indexes greater than 1
                end
                
            end

%             for j= 1:numel(ry)
%                 img(ry(j),rx(j)) = img(ry(j),rx(j)) * distanceBetweenCoordinates(ry(j),rx(j),middleHeight,middleWidth)/724;
%             end
            
            index = sub2ind(size(img),ry,rx);
            newImg(index)   = 255; %% set to white the ones who are in the angle
            %newImg(index+1) = 255;
            toSum = img(index);% lets sum from the original image instead of the new one
            
            %arrRes(j)   = sum(toSum);
            arrRes(j)   = sum(toSum)/numel(toSum);
            
        end
        j = j+1;
    end
    

end

