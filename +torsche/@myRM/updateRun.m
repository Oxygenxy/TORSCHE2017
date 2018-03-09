function I = updateRun( obj )
%UPDATERUN Summary of this function goes here
%   Detailed explanation goes here
    %abbleRun=[remainProc>0].*tempRels;
    I = find(obj.remainProc>0);
    [priResult,priIndex] = sort(obj.per(obj.remainProc>0),2,'ascend');
    if(I)
        I = I(priIndex);
    end




