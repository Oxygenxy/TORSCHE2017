t1 = ptask('t1',8,32);
t2 = ptask('t2',15,40);
t3 = ptask('t3',20,80);
ts = taskset([t1 t2 t3]);
tss = EDF(ts);
plot(tss);