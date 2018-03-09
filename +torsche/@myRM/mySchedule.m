function mySchedule( obj )
%MYSCHEDULE Summary of this function goes here
%   Detailed explanation goes here

while(obj.tmax<obj.tstop)
    
    I=updateRun(obj);
    if(I)
        
        tmaxPlus = obj.tmax+obj.remainProc(I(1));
        updateTempRels(obj);
        obj.minRels = min(obj.tempRels);
        if(tmaxPlus < obj.minRels)
        
            getAddScht(obj,I(1),obj.remainProc(I(1)));     
            obj.tmax = tmaxPlus;
            obj.remainProc(I(1)) = 0;
              
        elseif(tmaxPlus >= obj.minRels)
            
            getAddScht(obj,I(1),(obj.minRels-obj.tmax));
            obj.remainProc(I(1)) = obj.remainProc(I(1))-(obj.minRels-obj.tmax);
            obj.tmax = obj.minRels;
%            setDdleRemainProc(obj); 
            setDdleRemainProc(obj,obj.tempRels,obj.minRels);
        end
    else
        updateTempRels(obj);
        obj.minRels = min(obj.tempRels)
        obj.tmax=obj.minRels;
%       obj.tmax = min(updateTempRels(obj));
%        setDdleRemainProc(obj);
        setDdleRemainProc(obj,obj.tempRels,obj.minRels);
    end
    
end

%add_schedule(resultts, 'RM schedule');
temp=obj.resultts;
add_schedule(temp, 'RM schedule');
plot(obj.resultts);

