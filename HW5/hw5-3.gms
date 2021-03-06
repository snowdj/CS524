$title Open cast mining
set blocks  "total available blocks" /1*18/;
set level1_blocks(blocks) "level 1 blocks" /1*8/;
set level2_blocks(blocks) "level 2 blocks"/9*14/;
set level3_blocks(blocks) "level 3 blocks" /15*18/;
set quartz_blocks(blocks) "quartz blocks" /9, 14, 15, 16, 18/;
set uranium_blocks(blocks) "uranimum blocks" /1, 7, 10, 12, 17 ,18/;

scalar level_1_cost "cost to mine block in level1" /100/;
scalar level_2_cost "cost ot mine block in level2" /200/;
scalar level_3_cost "cost to mine block in level3"/300/;
scalar quartz_block_cost "cost to mine quartz block"/1000/;
parameter cost_of_extraction(blocks) "cost of extracting blocks";

cost_of_extraction(level1_blocks) = level_1_cost;
cost_of_extraction(level2_blocks) = level_2_cost;
cost_of_extraction(level3_blocks) = level_3_cost;
cost_of_extraction(quartz_blocks) = quartz_block_cost;
display cost_of_extraction;
parameter  market_value(uranium_blocks) "marketing value of level1 blocks"
     / 1    200   
       7    300
	     10   500
	     12   200
	     17   1000
	     18   1200
	                 /;

binary variables z(blocks) "indicator variable for the blocks";

free variable total_benefit "total benifit obtained from mining";
equations
  total_benefit_eq "objective equation ",
  level_3_constraint_eq(level3_blocks) "constraints for mining blocks in level3",
  level_2_constraint_eq(level2_blocks) "constraints for mining blocks in level3";
  
total_benefit_eq..
  total_benefit =e= sum (uranium_blocks, market_value(uranium_blocks)*10000*z(uranium_blocks)) - sum(blocks, 10000*cost_of_extraction(blocks)*z(blocks));

level_3_constraint_eq(level3_blocks)..
     sum(level2_blocks$(ord(level2_blocks) eq ord(level3_blocks)),z(level2_blocks)) + sum(level2_blocks$(ord(level2_blocks) eq ord(level3_blocks)+1),z(level2_blocks))
     + sum(level2_blocks$(ord(level2_blocks) eq ord(level3_blocks)+2),z(level2_blocks)) - z(level3_blocks) =g= 2;

level_2_constraint_eq(level2_blocks)..
    sum(level1_blocks$(ord(level2_blocks) eq ord(level1_blocks)),z(level1_blocks)) + sum(level1_blocks$(ord(level1_blocks) eq ord(level2_blocks)+1),z(level1_blocks))
    +sum(level1_blocks$(ord(level1_blocks) eq ord(level2_blocks)+2),z(level1_blocks)) - z(level2_blocks) =g= 2;

model open_cast_mining /all/;
solve open_cast_mining using mip maximing total_benefit;
