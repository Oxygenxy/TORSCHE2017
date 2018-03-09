function resultts = myRR1( ts,tSlice )


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

function addResultts(j) %add task with shcedule to resultts
        tempDdle=tempRels;
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

[priResult,queue] = sort(per,2,'ascend');
tempRels = per;

while((tmax < tstop)&queue)

    i=queue(1);
    
    if(~remainProc(i))
        queue(1) = [ ];
    elseif(remainProc(i)<=tSlice)
        
        queue(1) = [];
        getAddScht(i,remainProc(i));
        tmax = tmax+remainProc(i);
        remainProc(i) = 0;
        addResultts(i);
        
        while(1)
            I = find(tempRels  <= tmax);
        
            if(I)
                [temp,ind] = sort(tempRels(I),2,'ascend');
                queue = [queue I(ind)];
                tempRels(I) = tempRels(I)+per(I);
                remainProc(I) = c(I);
               
            end
        
            if(isempty(queue))
                tmax = min(tempRels);
            else
                break;
            end
        
        end
        
    else
        queue(1) = [];
        getAddScht(i,tSlice);
        remainProc(i) = remainProc(i)-tSlice;
        tmax = tmax+tSlice;
        
        I=find(tempRels  <= tmax);
        if(I)
            [temp,ind] = sort(tempRels(I),2,'ascend');
            queue = [queue I(ind)];
            tempRels(I) = tempRels(I)+per(I);
            remainProc(I) = c(I);
        end
        
        queue=[queue i];
        
    end
     
end

add_schedule(resultts, 'RM schedule');
end



