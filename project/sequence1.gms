$title Sequencing on a single machine (Xpress Models: pp 128-132)

$ontext
A set of tasks is to be processed on a single machine.
The execution of the tasks is non-preemptive (ie cannot be interrupted).
For every task i its release date, duration and due date are given.

What is the sequence that minimizes the maximum tardiness?

This formulation uses rank with sos1 variables
$offtext

set job / 1*7 /;
set times /release,duration,due/;

table data(times,job)
		1	2	3	4	5	6	7
release		2	5	4			8	9
duration	5	6	8	4	2	4	2
due		10	21	15	10	5	15	22
;

alias (job,j);
set k 'position' / p1*p7 /;

sos1 variable rank(j,k) "job j has position k";
positive variables start(k) "start time of job in position k";
positive variables comp(k) "completion time of job in position k";
positive variables tard(k) "tardiness of job in position k";
variable tardiness;

equations
  oneInPosition(k),
  oneRankPer(j),
  defstart(k),
  defcomp(k),
  precedence(k),
  deftard(k),
  deftardiness(k);

oneInPosition(k)..
  sum(j,rank(j,k)) =e= 1;

oneRankPer(j)..
  sum(k,rank(j,k)) =e= 1;

defstart(k)..
  start(k) =g= sum(j,data('release',j)*rank(j,k));

defcomp(k)..
  comp(k) =e= start(k) + sum(j,data('duration',j)*rank(j,k));

precedence(k)$(ord(k) lt card(k))..
  start(k+1) =g= comp(k);

* This is really max(0, comp(k) - sum(j,...))
deftard(k)..
  tard(k) =g= comp(k) - sum(j,data('due',j)*rank(j,k));

deftardiness(k)..
  tardiness =g= tard(k);

model sequence /all/;
sequence.optcr = 0;
solve sequence using mip min tardiness;
