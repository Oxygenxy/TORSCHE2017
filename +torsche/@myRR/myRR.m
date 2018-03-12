classdef myRR < torsche.myPTaskset
    %MYRR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tSlice=10
    end
    
    methods
        function obj=myRR(varargin)
            obj = obj@torsche.myPTaskset(varargin{:});
%             obj.tSlice = varargin{nargin};
            obj.feasibility();
            obj.mySchedule();
        end
    end
    
end

