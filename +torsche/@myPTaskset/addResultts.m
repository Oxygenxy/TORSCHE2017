function addResultts(obj,j) %add task with shcedule to resultts
        tempDdle=obj.tempRels;
        if isempty(obj.resultts)
            obj.readyTasks{j}.Deadline = tempDdle(j);
            obj.readyTasks{j}.ReleaseTime = tempDdle(j)-obj.per(j);
            obj.resultts = [obj.readyTasks{j}];
        else
            obj.readyTasks{j}.Deadline = tempDdle(j);
            obj.readyTasks{j}.ReleaseTime = tempDdle(j)-obj.per(j);
            obj.resultts = [obj.resultts obj.readyTasks{j}];
        end

