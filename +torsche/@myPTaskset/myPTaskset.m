classdef myPTaskset < handle&torsche.taskset
    %MYTASKSET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tmax=0
        tstop=1
        noft
        per
        c
        remainProc
        readyTasks
        resultts
        tempRels
    end
    
    methods
        function obj = myPTaskset(varargin)
            
%             obj =obj@handle(varargin);
            obj = obj@torsche.taskset(varargin{:});
            obj = colour(obj);
            initNoft(obj);
            initProcTime(obj);
            initTstop(obj);
            initRemainProc(obj);
            initReadyTasks(obj);
            updateTempRels(obj);
            
        end
        
        function initNoft(obj)
            obj.noft = size(obj.tasks,2);
        end
        
        function initProcTime(obj)
            
            obj.c = [];
            obj.per = [];
            for i = 1:obj.noft
               
                obj.c = [obj.c obj.tasks{i}.ProcTime];
                obj.per = [obj.per obj.tasks{i}.Period];
            end
            
        end
        
        function initRemainProc(obj)
            
            obj.remainProc = obj.c;
            
        end
        
        function initReadyTasks(obj)
            
            for i = 1:obj.noft  %init of readyasks

                pt = obj.tasks{i};
                pts = struct(pt);
                temptask = pts.parent;
                temptask.Processor = i; % Hack for plotting the schedule
                temptask.ReleaseTime = 0;
                temptask.Deadline = obj.per(i);
                obj.readyTasks{i} = temptask;   
                
            end
        end
        
        function updateTempRels(obj)
        
%            obj.tempRels=obj.per;
             obj.tempRels = (fix(obj.tmax./obj.per)+1).*obj.per;
        
        end
        
        function initTstop(obj)
            for i = 1:obj.noft
                obj.tstop = lcm(obj.tstop,obj.per(i));
            end
        end
    end
    
    methods (Abstract)
        mySchedule(obj)
    end
    
end

