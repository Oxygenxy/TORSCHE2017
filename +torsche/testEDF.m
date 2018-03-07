t1 = ptask(8,32);
t2 = ptask(15,40);
t3 = ptask(20,80);
ts = taskset([t1 t2 t3]);
tss = myEDF(ts);
% tss = myRR(ts,1000);

% plot(tss,'TimeMultiple','');
plot(tss,'Axname',{'task1','task2','task3'});