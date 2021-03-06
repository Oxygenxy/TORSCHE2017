function mySchedule( obj )

[priResult,queue] = sort(obj.per,2,'ascend');


while(obj.tmax < obj.tstop)

    i=queue(1);
    
    if(~obj.remainProc(i))
        queue(1) = [ ];
    elseif(obj.remainProc(i)<=obj.tSlice)
        
        queue(1) = [];
        getAddScht(obj,i,obj.remainProc(i));
        obj.tmax = obj.tmax+obj.remainProc(i);
        obj.remainProc(i) = 0;
        addResultts(obj,i);
        
        while(1)
            I = find(obj.tempRels  <= obj.tmax);
        
            if(I)
                [temp,ind] = sort(obj.tempRels(I),2,'ascend');
                queue = [queue I(ind)];
                obj.tempRels(I) = obj.tempRels(I)+obj.per(I);
                obj.remainProc(I) = obj.c(I);
               
            end
        
            if(isempty(queue))
                obj.tmax = min(obj.tempRels);
            else
                break;
            end
        
        end
        
    else
        queue(1) = [];
        getAddScht(obj,i,obj.tSlice);
        obj.remainProc(i) = obj.remainProc(i)-obj.tSlice;
        obj.tmax = obj.tmax+obj.tSlice;
        
        I=find(obj.tempRels  <= obj.tmax);
        if(I)
            [temp,ind] = sort(obj.tempRels(I),2,'ascend');
            queue = [queue I(ind)];
            obj.tempRels(I) = obj.tempRels(I)+obj.per(I);
            obj.remainProc(I) = obj.c(I);
        end
        
        queue=[queue i];
        
    end
     
end

%obj.resultts=colour(obj.resultts);

temp=obj.resultts;
add_schedule(temp, 'RR schedule');
%obj.resultts.schedule.is = 1;

plot(obj.resultts,'Axname',{'task1','task2','task3'});
%plot(obj.resultts);

