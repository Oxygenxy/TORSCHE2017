classdef myRM < torsche.myPTaskset
    %MYRM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
            minRels
    end
    
    methods
        function obj=myRM(varargin)
            obj = obj@torsche.myPTaskset(varargin{:});
%             obj.tSlice = varargin{nargin};
            obj.mySchedule();
        end
    end
    
end
