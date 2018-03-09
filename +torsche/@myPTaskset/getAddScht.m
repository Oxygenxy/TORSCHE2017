function getAddScht(obj,j,process) % get task and set task
    
        [start, len, processor] = get_scht(obj.readyTasks{j});
     
        start = [start obj.tmax];
        len = [len process];
        processor = [processor obj.readyTasks{j}.Processor];
         
        obj.readyTasks{j} = add_scht(obj.readyTasks{j}, start, len, processor);

