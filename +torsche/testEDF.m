flag = 1;

t1 = ptask(8,32);
t2 = ptask(15,40);
t3 = ptask(20,80);
ts = taskset([t1 t2 t3]);

if(flag)
    myRR(ts);
else
    tss = myRR1(ts,10);

% plot(tss,'TimeMultiple','');
  plot(tss,'Axname',{'task1','task2','task3'});
 %   plot(tss,'Axis',10);
end