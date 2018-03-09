classdef myEDF < torsche.myPTaskset
    %MYEDF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj=myEDF(varargin)
            obj = obj@torsche.myPTaskset(varargin{:});
%           obj.tSlice = varargin{nargin};
            obj.mySchedule();
        end
    end
    
end

