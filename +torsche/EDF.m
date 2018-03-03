function resultts = EDF(ts)

resultts = [];
ts=colour(ts);

c    =  ts.ProcTime;
per  =  ts.Period;

noft=size(c,2);

tmax=0;
tstop=1;
remainProc = c;

for i = 1:noft
    tstop = lcm(tstop, per(i));
end

%ddleLower = (fix(tamx./per)).*per;
%ddleUpper = (fix(tamx./per)+1).*per;
%[minDdle,indexDdle]=min((fix(tmax./per)+1).*per);
for i = 1:noft

    pt = ts.tasks(i);
    pts = struct(pt);
    temptask = pts.parent;
    temptask.Processor = i; % Hack for plotting the schedule
    temptask.ReleaseTime = 0;
    temptask.Deadline = per(i);
    readyTasks{i} = temptask;   
    
end

function add_to_ready(j)
    
    readyTasks{j}.Processor = j; % Hack for plotting the schedule
    if(fix(tmax/per(j))==0)
        readyTasks{j}.ReleaseTime = tmax;
    end
    readyTasks{j}.Deadline = tempDdle(j); 
end

function I = findEqual(x,k)
        I=[];
        col=size(x,2);
        for i=1:col
            if(x(i)==k)
                I=[I i];
            end
        end
end

function addResultts(j)
        if isempty(resultts)
            readyTasks{j}.Deadline=tempDdle(j);
            readyTasks{j}.ReleaseTime=tempDdle(j)-per(j);
            resultts = [readyTasks{j}];
        else
            readyTasks{j}.Deadline=tempDdle(j);
            readyTasks{j}.ReleaseTime=tempDdle(j)-per(j);
            resultts = [resultts readyTasks{j}];
        end
end

while(tmax<tstop)

tempDdle = (fix(tmax./per)+1).*per;
[ddleResult,ddleIndex]=sort(tempDdle,2,'ascend');


%tempProced=tmax-ddleLower;
%remainProc=c-tempProced;

for i=1:noft
    j = ddleIndex(i);
    edRem = remainProc(j);
    tmaxPlus = tmax+edRem;
   if(~edRem) 
       continue;
   elseif(tmaxPlus<=ddleResult(1))
       
       add_to_ready(j);
       [start, len, processor] = get_scht(readyTasks{j});
      
       
       start=[start tmax];
       len=[len edRem];
       processor = [processor readyTasks{j}.Processor];
       readyTasks{j} = add_scht(readyTasks{j}, start, len, processor);
       
       tmax = tmax+edRem;
       remainProc(j) = 0;
       

%       if isempty(resultts)
%           resultts = [readyTasks{j}];
%       else
%            resultts = [resultts readyTasks{j}];
%       end
       
       if(tmaxPlus==ddleResult(1))
           I=findEqual(tempDdle,ddleResult(1));
           for k=1:size(I,2)
               index=I(k);
               remainProc(index) = c(index);
               addResultts(index);
           end
           break;
       end
       
       continue;
   
   elseif(tmaxPlus>ddleResult(1))
       
       add_to_ready(j);
       [start, len, processor] = get_scht(readyTasks{j});
       
       
       start=[start tmax];
       len=[len (ddleResult(1)-tmax)];
       processor = [processor readyTasks{j}.Processor];
       readyTasks{j} = add_scht(readyTasks{j}, start, len, processor);
       
       remainProc(j) = remainProc(j)-(ddleResult(1)-tmax);
       tmax = ddleResult(1);
       
        I=findEqual(tempDdle,ddleResult(1));
        for k=1:size(I,2)
               index=I(k);
               remainProc(index) = c(index);
               addResultts(index);
        end
       %remainProc(ddleIndex(1)) = c(ddleIndex(1));
       break;
   end
end

if(tmax<ddleResult(1))
    tmax=ddleResult(1);
    I=findEqual(tempDdle,ddleResult(1));
        for k=1:size(I,2)
               index=I(k);
               remainProc(index) = c(index);
               addResultts(index);
        end
end
        

end

add_schedule(resultts, 'EDF schedule');

end

