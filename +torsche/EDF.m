function resultts = EDF(ts)

resultts = [];  %to store task with schedule
ts=colour(ts);

c    =  ts.ProcTime;    
per  =  ts.Period;
remainProc = c; %remain ProcTime need to be process

noft = size(c,2);   %numbers of tasks

tmax = 0;   %time axis
tstop = 1;  %stop time


for i = 1:noft
    tstop = lcm(tstop, per(i)); %tstop equal to least common multiple of peroids
end

for i = 1:noft  %init of readyasks

    pt = ts.tasks(i);
    pts = struct(pt);
    temptask = pts.parent;
    temptask.Processor = i; % Hack for plotting the schedule
    temptask.ReleaseTime = 0;
    temptask.Deadline = per(i);
    readyTasks{i} = temptask;   
    
end


function I = findEqual(x,k) %find numbers in array x to equal to k and return index
        I = [];
        col = size(x,2);
        for i = 1:col
            if(x(i)==k)
                I = [I i];
            end
        end
end


function addResultts(j) %add task with shcedule to resultts
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

function getAddScht(j,process) % get task and set task
    
        [start, len, processor] = get_scht(readyTasks{j});
     
        start = [start tmax];
        len = [len process];
        processor = [processor readyTasks{j}.Processor];
         
        readyTasks{j} = add_scht(readyTasks{j}, start, len, processor);
end

function setDdleRemainProc() % if time over Deadline then reset remainProc to equal to proctime
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
        edRem = remainProc(j); % edRem denotes remain process time of earliest deadline task in current peroid
        tmaxPlus = tmax+edRem;
        if(~edRem) % remain process time equal to zero?current task need not to be executed
            continue;
        elseif(tmaxPlus<ddleResult(1)) % if tmax add to edRem less than earliest deadline,task j can be fully executed at current period

            getAddScht(j,edRem);
            remainProc(j) = 0;
            tmax = tmax+edRem;
       
            continue;
   
        elseif(tmaxPlus>=ddleResult(1)) % if tmax add to edRem less than earliest deadline,task j can be partly executed at current period
      
            getAddScht(j,(ddleResult(1)-tmax));       
            remainProc(j) = remainProc(j)-(ddleResult(1)-tmax);
            tmax = ddleResult(1);
            setDdleRemainProc();% update remain process time of earliest deadline task
            
            break;
        end
    end

    if(tmax<ddleResult(1)) % if loop is done ,there is no task to be executed  in current period
        tmax = ddleResult(1);
        setDdleRemainProc();
    end
        

end

add_schedule(resultts, 'EDF schedule');

end

