optimise_arbitrage(data = data.frame(price = c(5.0, 5.0, 10.0, 10.0)),
    price_from = 'price', capacity = 1, c_rate = 1)
optimise_arbitrage(data = data.frame(price = c(5.0, 5.0, 10.0, 10.0)),
    price_from = 'price', capacity = 1, c_rate = 1, efficiency = .7)
optimise_arbitrage(data = data.frame(price = c(5.0, 5.0, 10.0, 10.0),
                                     exclude = c(0, 1, 1, 0)),
    price_from = 'price', capacity = 1, c_rate = 1, efficiency = .7)
optimise_arbitrage(data = data.frame(price = c(5.0, 5.0, 10.0, 10.0),
                                     exclude = c(0, 1, 1, 0),
                                     max_charge = c(NA, .4, NA, NA),
                                     min_charge = c(NA, .2, NA, NA)),
    price_from = 'price', capacity = 1, c_rate = 1, efficiency = .7)
optimise_arbitrage(data = data.frame(price = c(5.0, 5.0, 10.0, 10.0)),
    price_from = 'price', capacity = 1, c_rate = 1, deg_cost_per_cycle = 2.0)
