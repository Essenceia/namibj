# Top level testbench 

## Filter 

Since, even without increasing the test iteration count, this testbench 
is massive and contains multiple test (especially for stressing different corner
cases of the switch), users might want to target a specific single test. 

This is done by filtering the test via setting the `COCOTB_TEST_FILTER` 
environement variable. 

eg : 
```
make sim COCOTB_TEST_FILTER="chip_top_tb.coldbrew_update_eth_config"
```

## Seeding randomization 

By default the test randomization is seeded with the system time. 

The current seed will be printed in the log at the start of each test.
```
random seed 1783876989276535066
```

In order to exactly replay a test the seed can be manually set by 
setting the `SEED` environement variable. 

eg : 
```
make sim SEED=1783876989276535066
```

## Test iteration 

You can increase the number of iterations of each test via the 
`TEST_ITER` environement variable. But, beware, by default this 
testbench dumps the waves, makes sure the waves are dissabled before 
increasing the iteration count too much else this will easily generate
10's of Gbs of waves. 

eg : 
```
make sim TEST_ITER=1000
```

Default value is set to `10` .

## Waves 

Was are dumped by default, to dissable waves set `WAVES = 0`.

```
make sim WAVES=0
``` 
