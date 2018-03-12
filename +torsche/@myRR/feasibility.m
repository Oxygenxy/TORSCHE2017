function feasibility( obj )
%FEASIBILITY Summary of this function goes here
%   Detailed explanation goes here
if(sum(obj.c./obj.per)>1)
    msgbox('Sorry,can''t schedule');
end

