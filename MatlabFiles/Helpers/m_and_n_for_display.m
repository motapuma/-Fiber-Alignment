function [ m, n ] = m_and_n_for_display( nEle )
%M_AND_N_FOR_DISPLAY Summary of this function goes here
%   Detailed explanation goes here


    switch nEle
        case 1
            m=1;
            n=1;
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
    
    
    

end

