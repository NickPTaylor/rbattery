test_that("correct power returned", {
    expect_equal(get_power(capacity = 2, c_rate = 1), 2)
    expect_equal(get_power(capacity = 2, c_rate = 2), 4)
    expect_equal(get_power(capacity = 2, c_rate = .5), 1)
})

test_that("error on incorrect argument classes", {
    expect_error(get_power(capacity = "two", c_rate = 1), "is.numeric")
    expect_error(get_power(capacity = 2, c_rate = "one"), "is.numeric")
})

test_that("error on arguments out of required range", {
    expect_error(get_power(capacity = -1, c_rate = 1), "must be greater")
    expect_error(get_power(capacity = 0, c_rate = 1), "must be greater")
    expect_error(get_power(capacity = 1, c_rate = -1), "must be greater")
    expect_error(get_power(capacity = 1, c_rate = 0), "must be greater")
})