flag = 3;

t1 = ptask(8,32);
t2 = ptask(15,40);
t3 = ptask(20,80);
ts = taskset([t1 t2 t3]);

if(flag==1)
    myRR(ts);
elseif(flag==2)
    tss = myRR1(ts,10);
% plot(tss,'TimeMultiple','');
  plot(tss,'Axname',{'task1','task2','task3'});
 %   plot(tss,'Axis',10);
 
elseif(flag==3)
    tss=myRM1(ts);
    plot(tss);
end