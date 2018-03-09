function setDdleRemainProc(obj,array,scalar) % if time over Deadline then reset remainProc to equal to proctime
         %tempRels=updateRels();
         indE = find(array==scalar);
         for k = 1:size(indE,2)
            index = indE(k);
            if(obj.remainProc(index)>0)
                msgbox('time exceed');
            end
            obj.remainProc(index) = obj.c(index);
            obj.addResultts(index);
         end


