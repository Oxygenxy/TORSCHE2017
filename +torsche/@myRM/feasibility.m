function feasibility( obj )
%FEASIBILITY Summary of this function goes here
%   Detailed explanation goes here

U=obj.c./obj.per;
H=log2(obj.per)-floor(log2(obj.per));

B=max(H)-min(H);%feasibilty judge
if(B<(1-1/obj.noft))
    if(U>((obj.noft-1)*(power(2,B/(obj.noft-1))-1)+power(2,1-B)))
        msgbox('Sorry,can''schedule');
    end
elseif(U>noft*(power(2,1/noft)-1))
    msgbox('Sorry,can''schedule');  
end


