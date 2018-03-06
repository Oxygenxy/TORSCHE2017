t1 = ptask('task1',8,32);
t2 = ptask('task2',15,40);
t3 = ptask('task3',20,80);
ts = taskset([t1 t2 t3]);
tss = myRM(ts);
plot(tss);