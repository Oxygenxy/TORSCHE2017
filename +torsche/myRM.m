function resultts = myRM(ts)

resultts = [];  %to store task with schedule
ts=colour(ts);

c    =  ts.ProcTime;    
per  =  ts.Period;


remainProc = c; %remain ProcTime need to be process
tempRels = [];

noft = size(c,2);   %numbers of tasks

U=c./per;
H=log2(per)-floor(log2(per));

B=max(H)-min(H);%feasibilty judge
if(B<(1-1/noft))
    if(U>((noft-1)*(power(2,B/(noft-1))-1)+power(2,1-B)))
        msgbox('Sorry,can''schedule');
    end
elseif(U>noft*(power(2,1/noft)-1))
    msgbox('Sorry,can''schedule');  
end


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

function tempRels = updateRels()
    tempRels = (fix(tmax./per)+1).*per;
end

function I = updateRun()
    %abbleRun=[remainProc>0].*tempRels;
    I = find(remainProc>0);
    [priResult,priIndex] = sort(per(remainProc>0),2,'ascend');
    if(I)
        I = I(priIndex);
    end
end

function getAddScht(j,process) % get task and set task
    
        [start, len, processor] = get_scht(readyTasks{j});
     
        start = [start tmax];
        len = [len process];
        processor = [processor readyTasks{j}.Processor];
         
        readyTasks{j} = add_scht(readyTasks{j}, start, len, processor);
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

function setDdleRemainProc() % if time over Deadline then reset remainProc to equal to proctime
         %tempRels=updateRels();
         indE = find(tempRels==minRels);
         for k = 1:size(indE,2)
            index = indE(k);
            if(remainProc(index)>0)
                msgbox('time exceed');
            end
            remainProc(index) = c(index);
            addResultts(index);
         end
end


while(tmax<tstop)
    
    I=updateRun();
    if(I)
        
        tmaxPlus = tmax+remainProc(I(1));
        tempRels = updateRels();
        minRels = min(tempRels);
        if(tmaxPlus < minRels)
        
            getAddScht(I(1),remainProc(I(1)));     
            tmax = tmaxPlus;
            remainProc(I(1)) = 0;
              
        elseif(tmaxPlus >= minRels)
            
            getAddScht(I(1),(minRels-tmax));
            remainProc(I(1)) = remainProc(I(1))-(minRels-tmax);
            tmax = minRels;
            setDdleRemainProc();  
        end
    else
        tmax = min(updateRels());
        setDdleRemainProc();
    end
    
end

add_schedule(resultts, 'RM schedule');

end


