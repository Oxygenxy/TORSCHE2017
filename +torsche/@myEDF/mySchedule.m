function mySchedule( obj )

while(obj.tmax<obj.tstop)

tempDdle = (fix(obj.tmax./obj.per)+1).*obj.per;
obj.tempRels = tempDdle;
[ddleResult,ddleIndex] = sort(tempDdle,2,'ascend');


    for i = 1:obj.noft
        j = ddleIndex(i);
        edRem = obj.remainProc(j); % edRem denotes remain process time of earliest deadline task in current peroid
        tmaxPlus = obj.tmax+edRem;
        if(~edRem) % remain process time equal to zero?current task need not to be executed
            continue;
        elseif(tmaxPlus<ddleResult(1)) % if tmax add to edRem less than earliest deadline,task j can be fully executed at current period

            getAddScht(obj,j,edRem);
            obj.remainProc(j) = 0;
            obj.tmax = obj.tmax+edRem;
       
            continue;
   
        elseif(tmaxPlus>=ddleResult(1)) % if tmax add to edRem less than earliest deadline,task j can be partly executed at current period
      
            getAddScht(obj,j,(ddleResult(1)-obj.tmax));       
            obj.remainProc(j) = obj.remainProc(j)-(ddleResult(1)-obj.tmax);
            obj.tmax = ddleResult(1);
            obj.tempRels = tempDdle;
            setDdleRemainProc(obj,tempDdle,ddleResult(1));% update remain process time of earliest deadline task
            
            break;
        end
    end

    if(obj.tmax<ddleResult(1)) % if loop is done ,there is no task to be executed  in current period
        obj.tmax = ddleResult(1);
        %setDdleRemainProc(obj);
        obj.tempRels = tempDdle;
        setDdleRemainProc(obj,tempDdle,ddleResult(1));
    end
        

end

obj.resultts.schedule.is = 1 %equal to add_schedule(resultts, 'EDF schedule');

plot(obj.resultts);




