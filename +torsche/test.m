function test( str )
%TEST Summary of this function goes here
%   Detailed explanation goes here

t1 = ptask(8,32);
t2 = ptask(15,40);
t3 = ptask(20,80);
ts = taskset([t1 t2 t3]);

switch str
    case 'RM'
        myRM(ts);
    case 'RR'
        myRR(ts);
    case 'EDF'
        myEDF(ts);

end

