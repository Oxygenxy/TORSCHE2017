function resultts = EDF(ts)

resultts = [];
ts=colour(ts);

c    =  ts.ProcTime;
per  =  ts.Period;
remainProc = c;

noft = size(c,2);

tmax = 0;
tstop = 1;


for i = 1:noft
    tstop = lcm(tstop, per(i));
end

for i = 1:noft

    pt = ts.tasks(i);
    pts = struct(pt);
    temptask = pts.parent;
    temptask.Processor = i; % Hack for plotting the schedule
    temptask.ReleaseTime = 0;
    temptask.Deadline = per(i);
    readyTasks{i} = temptask;   
    
end


function I = findEqual(x,k)
        I = [];
        col = size(x,2);
        for i = 1:col
            if(x(i)==k)
                I = [I i];
            end
        end
end


function addResultts(j)
        if isempty(resultts)
            readyTasks{j}.Deadline = tempDdle(j);
            readyTasks{j}.ReleaseTime = tempDdle(j)-per(j);
            resultts = [readyTasks{j}];
        else
            readyTasks{j}.Deadline = tempDdle(j);
            readyTasks{j}.ReleaseTime = tempDdle(j)-per(j);
            resultts = [resultts readyTasks{j}];
        end
end

function getAddScht(j,process)
    
        [start, len, processor] = get_scht(readyTasks{j});
     
         start = [start tmax];
         len = [len process];
         processor = [processor readyTasks{j}.Processor];
         
         readyTasks{j} = add_scht(readyTasks{j}, start, len, processor);
end

function setDdleRemainProc()
         I = findEqual(tempDdle,ddleResult(1));
         for k = 1:size(I,2)
            index = I(k);
            remainProc(index) = c(index);
            addResultts(index);
         end
end

while(tmax<tstop)

tempDdle = (fix(tmax./per)+1).*per;
[ddleResult,ddleIndex] = sort(tempDdle,2,'ascend');


    for i = 1:noft
        j = ddleIndex(i);
        edRem = remainProc(j);
        tmaxPlus = tmax+edRem;
        if(~edRem) 
            continue;
        elseif(tmaxPlus<ddleResult(1))

            getAddScht(j,edRem);
            remainProc(j) = 0;
            tmax = tmax+edRem;
       
            continue;
   
        elseif(tmaxPlus>=ddleResult(1))
      
            getAddScht(j,(ddleResult(1)-tmax));       
            remainProc(j) = remainProc(j)-(ddleResult(1)-tmax);
            tmax = ddleResult(1);
            setDdleRemainProc();
            
            break;
        end
    end

    if(tmax<ddleResult(1))
        tmax = ddleResult(1);
        setDdleRemainProc();
    end
        

end

add_schedule(resultts, 'EDF schedule');

end

