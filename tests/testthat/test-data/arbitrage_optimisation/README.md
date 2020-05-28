# Test Description

The tests defined in this folder are verification tests for the optimisation algorithm.  These test are developed and reviewed by a non-R user so they have been isolated from the unit test code.  They are loaded via a fixture in the unit tests.

## idle_battery

Check that the battery is idle when it is supposed to be.

1. Since the spot price is the same for all settlement periods, the battery should do nothing.  Note that the battery should not charge up for 2 period and then discharge for 2 since the net result is 0 income i.e. the same as doing nothing.  The latter cases is undesirable since there is a cost of degradation associated with the battery operating.  (Currently, this is accounted for with a simple constant cost for each period that the battery charges/discharges).

2. Ideally, the battery would charge at the higher initial spot prices.  However, since the battery has 0 charge to start with, it is unable to do this.  Therefore the battery is idle for the entire test period.

## simple_charge_discharge

Simple scenarios for testing appropriate charging and discharging.

1. Charge up to begin with since the spot price is low and then discharge making a profit.

2. Almost as easy as test 1, except now, the discharge spot prices are not fixed.

3. In this case, the pair with the largest differential is the 1/10 spot price pair.  Hence, charge on 1 and discharge on 10.  A profit cannot be made from the remaining pair so the battery should be idle.

4 and 5. This test relates to a bug.  The charge state of the battery refers to the charge state at the beginning of the settlement period.  This must be greater than 0.  For the last period, it is important to check that the battery does not discharge below 0 at the *end* of the period!  Previously, this constraint had been forgotten.  In test 4, the battery charges over period 1 and 2, discharges on 3 and 5 and is idle for 4.  In test 5, the battery charges over period 1 and 2, discharges over 3 and 4 and is idle for 5.  This behaviour is correct i.e. on test 4, the battery not discharge so that it was below capacity on the last period.

## init_charge

Check that init_charge is handled correctly.

1. First test is a control.

2. In the second test, the initial charge is set to 0.5.  Since the battery starts with some charge, the optimum behaviour will be to discharge all of this when the price is favourable and to charge what ever is possible at the lowest price.

## settlement_period

Check that settlement period is handled correctly.

1. First test is control.

2. Second test is similar to the first test except that the settlement period is set to .25 i.e half of the time of the first one.  The optimum behaviour is the same but the income is halved since the time period is halved.

## battery_efficiency

If the battery is 100% efficient, arbitrage profit is made on any spot price differential.  With an efficiency account, this is not true since some energy is lost and this at cost.  Ignoring degradation (this has been set to a very low number so it is insignificant), a profit is made if:

  C-/C+ > efficiency ** 2

where C-/C+ is the ratio of a discharge/charge spot price pair.  These tests check that the algorithm takes advantage of a profit when the above is favourable and remains idle when it is not.

1. The efficiency is 100% and this is very favourable.

2. The efficiency is set so that it is marginally favourable.  It is expected that the battery will operate and make a small profit.

3. The efficiency is set so that is is marginally unfavourable.  The battery should be idle to avoid making a loss.

## charge_rate

These tests check that the battery makes optimal use of charging speed.

1. The battery is able to make full use of the low starting spot price over the first two periods by charging to capacity.  Then, it discharges over the two periods with the highest spot price.

2. In this case, the c-rate is lower so the battery can only half fill over during the first two periods.  Therefore, it also charges at the lower spot prices over the next two periods to capacity.

3. In this case, the battery fully charges over one period.  Notice that the battery is idle for the last two periods since the price differential is not favourable.

4. This is similar to test 3 except that the last two spot prices are switched, therefore the battery will charge/discharge to make a profit.

## partial_operation

Check that the optimisation handles cases where during a settlement period, the battery can use part of the time to charge/discharge to capacity/empty whilst being idle for the remaining time.

1. The charge rate is set such that on the 2nd period, only .6 of the time is required to charge the battery to capacity and on the 4th period, on .6 of the time is required to discharge the battery to empty

## no_arbitrage

Check whether the control to stop arbitrage during certain periods works properly.

1. In this test, the battery is free to charge/discharge during periods when the spot prices is the most favourable.

2. The spot prices are the same as test 1 but now the battery is restricted to be idle during periods 2-3.  The test checks the optimisation algorithm enforces the idle condition.

3. This is similar to test 2 but the idle conditions are set for periods 1, 3, 5

## max_min_charge

Check that conditions on maximum and minimum charge are applied correctly.  Conditions on maximum/minimum charge are usually used in conjunction with disabling arbitrage optimisation so this is reflected in the unit tests.

1. The first test has no conditions so arbitrage is optimised as usual.

2. This test has the same input as the first except arbitrage is disabled for periods 5-8.  As a result, the income is lower than optimum arbitrage.

3. This test is the same as the second except a minimum charge is specified for period 5.  As a result, the battery cannot take full advantage of favourable spot prices and the income is lower still.

4. Further constraints are added to the above test, excluding arbitrage in periods 11-12 and imposing a minimum charge for period 11.  As a result, the income is negative i.e. the only way of satisfying the constraints on minimum charge is to charge the battery at a loss.

5. This test is paired with test 6.  Arbitrage is disabled in periods 4-7.

6. In addition to the above, a maximum charge is specified for period 4.  This restricts the battery from charging when it is favourable to do so, hence, compared to test 5, the income is reduced.

## degradation

Check degradation formula applied properly

1. No degradation.

2. Degradation cost of £2.99/per cycle applied.  If the battery charges and discharges, it is marginally profitable at this level.  i.e. sum of arbitrage income and degradation lost is £0.01.

2. Degradation cost of £3.00/per cycle applied.  It is not profitable for the battery to operate at this degradation cost.

## AK_tests

Tests prepared and documented by Alex Kleidaras.

A series of simple tests which progress with minimal input changes from the previous.  These are designed to check that the optimization algorithm is giving sensible output and that constraints are not violated.  Performance is checked by comparing the output and the expected output.

N.B.: Degradation cost is per cycle (e.g. half for 1 charge or discharge) and income takes degradation cost in consideration.

1.  Test 1 is a simple test to check that the algorithm picks the lowest spot price to charge and highest to discharge, among a number of values.

2. Same as test 1, but a single spot price change.

3. Same as test 1, but different efficiency and degradation cost.  The algorithm should not discharge and/or charge.

4. Same as test 1, but different efficiency and degradation cost.  The algorithm should not discharge and/or charge.

5. Tests 5-8 are similar to tests 1-4, using negative Spot Prices as well.  Similar behaviour between tests 1, 2 and tests 5, 6 should be seen. 
For test 7 though it will be different.  For negative values, irrespectively of the efficiency, charging is always profitable.  Different behaviour between test 3 and test 7 should be seen, but not between test 4 and test 8.

6. See above.

7. See above.

8. See above.

9. In tests 9-14 the capacity and c_rate change so consecutive charges and discharges are possible.  This increases greatly the potential combinations of charging and discharging and the behaviour between max and min values.

10. Similar to test 2 and test 5.

11. Initial SoC reduces charging periods, or increases discharging ones.  This will be the case after an FFR period.

12. This could be the case after an FFR period where the battery solution was called for high frequency regulation.  Unluckily to reach 100% charge though.

13. This will be the case before the FFR.  Battery solution needs to have a minimum SoC.

14. Unluckily to happen but good to test the algorithm. 