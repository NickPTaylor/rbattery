# Test valid arguments do not generate error ------------------------------

test_that("test valid arguments", {

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1
        ),
        NA
    )

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            efficiency = 1,
        ),
        NA
    )

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c(FALSE, TRUE)
            ),
            price_from = 'price',
            exclude_from = 'exclude',
            capacity = 1,
            c_rate = 1,
            efficiency = 1,
        ),
        NA
    )

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c(1L, 0L)
            ),
            price_from = 'price',
            exclude_from = 'exclude',
            capacity = 1,
            c_rate = 1,
            efficiency = 1,
        ),
        NA
    )

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c(1, 0)
            ),
            price_from = 'price',
            exclude_from = 'exclude',
            capacity = 1,
            c_rate = 1,
            efficiency = 1,
        ),
        NA
    )

    expect_error(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c(0, 0),
                min_charge = c(0, 0),
                max_charge = c(.6, .5)
            ),
            price_from = 'price',
            exclude_from = 'exclude',
            min_charge_from = 'min_charge',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1,
            efficiency = 1,
            init_charge = .6,
        ),
        NA
    )

})

# Test invalid argument types raise exception. ----------------------------

test_that("test invalid `data` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = list(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'data')
    expect_equal(err$must_be, 'data.frame')
    expect_equal(err$not, 'list')

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = NULL,
            price_from = 'price',
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$must_be, 'data.frame')
    expect_equal(err$not, 'NULL')

})

test_that("test invalid `price_from` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4),
                exclude = c(0, 0, 0, 0),
                min_charge = c(0, 0, 0, 0),
                max_charge = c(1, 1, 1, 1)
            ),
            price_from = 1,
            exclude_from = 'exclude',
            min_charge_from = 'min_charge',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'price_from')
    expect_equal(err$must_be, 'character')
    expect_equal(err$not, 'double')

})

test_that("test invalid `exclude_from` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4),
                exclude = c(0, 0, 0, 0)
            ),
            price_from = 'price',
            exclude_from = TRUE,
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'exclude_from')
    expect_equal(err$must_be, 'character')
    expect_equal(err$not, 'logical')

})

test_that("test invalid `min_charge_from` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4),
                min_charge = c(0, 0, 0, 0)
            ),
            price_from = 'price',
            min_charge_from = 1L,
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'min_charge_from')
    expect_equal(err$must_be, 'character')
    expect_equal(err$not, 'integer')
})

test_that("test invalid `max_charge_from` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4),
                max_charge = c(1, 1, 1, 1)
            ),
            price_from = 'price',
            max_charge_from = 1L,
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'max_charge_from')
    expect_equal(err$must_be, 'character')
    expect_equal(err$not, 'integer')

})

test_that("test invalid `capacity` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 'one',
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'capacity')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("test invalid `c_rate` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 'one'
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'c_rate')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("test invalid `efficiency` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            efficiency = 'one'
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'efficiency')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("test invalid `t_period` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            t_period = 'one'
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 't_period')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("test invalid `init_charge` argument type raises error", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2, 3, 4)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            init_charge = 'one'
        )
    )
    expect_s3_class(err, 'error_bad_argument_type')
    expect_equal(err$arg, 'init_charge')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})


# Invalid `data` argument raises exception --------------------------------

test_that("`data` with less than 2 rows raises exception", {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            efficiency = 1
        )
    )
    expect_s3_class(err, 'error_bad_shape')
    expect_equal(err$obj, 'data')
    expect_equal(err$check, 'nrow')
    expect_equal(err$must_be, "> 1")
    expect_equal(err$not, 0)

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = 1
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_bad_shape')
    expect_equal(err$obj, 'data')
    expect_equal(err$check, 'nrow')
    expect_equal(err$must_be, '> 1')
    expect_equal(err$not, 1)

})

test_that("invalid `price` column type raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c("one", "two"),
                stringsAsFactors = FALSE
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_column_type')
    expect_equal(err$column, 'price')
    expect_equal(err$in_df, 'data')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("invalid `exclude_from` column type raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c("one", "two"),
                stringsAsFactors = FALSE
            ),
            price_from = 'price',
            exclude_from = 'exclude',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_column_type')
    expect_equal(err$column, 'exclude')
    expect_equal(err$in_df, 'data')
    expect_equal(err$must_be, 'logical or numeric')
    expect_equal(err$not, 'character')

})

test_that("invalid `min_charge_from` column type raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                min_charge = c("zero", "zero"),
                stringsAsFactors = FALSE
            ),
            price_from = 'price',
            min_charge_from = 'min_charge',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_column_type')
    expect_equal(err$column, 'min_charge')
    expect_equal(err$in_df, 'data')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("invalid `max_charge_from` column type raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c("one", "one"),
                stringsAsFactors = FALSE
            ),
            price_from = 'price',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_column_type')
    expect_equal(err$column, 'max_charge')
    expect_equal(err$in_df, 'data')
    expect_equal(err$must_be, 'numeric')
    expect_equal(err$not, 'character')

})

test_that("non-existant `price_from` column raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price_not_there',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_name')
    expect_equal(err$name, 'price_not_there')
    expect_equal(err$not_in_df, 'data')

})

test_that("non-existant `exclude_from` column raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                exclude = c(0, 0)
            ),
            price_from = 'price',
            exclude_from = 'exclude_not_there',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_name')
    expect_equal(err$name, 'exclude_not_there')
    expect_equal(err$not_in_df, 'data')

})

test_that("non-existant `min_charge_from` column raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                min_charge = c(0, 0)
            ),
            price_from = 'price',
            min_charge_from = 'min_charge_not_there',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_name')
    expect_equal(err$name, 'min_charge_not_there')
    expect_equal(err$not_in_df, 'data')

})

test_that("non-existant `max_charge_from` column raises exception", {

    err <- rlang::catch_cnd({
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c(1, 1)
            ),
            price_from = 'price',
            max_charge_from = 'max_charge_not_there',
            capacity = 1,
            c_rate = 1
        )
    })
    expect_s3_class(err, 'error_bad_name')
    expect_equal(err$name, 'max_charge_not_there')
    expect_equal(err$not_in_df, 'data')

})

test_that('test invalid capacity value raises exception ', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 0,
            c_rate = 1
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'capacity')
    expect_equal(err$must_be, '> 0')
    expect_equal(err$not, 0)

})

test_that('test invalid c_rate value raises exception ', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 0
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'c_rate')
    expect_equal(err$must_be, '> 0')
    expect_equal(err$not, 0)

})

test_that('test invalid t_period value raises exception ', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            t_period = 0
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 't_period')
    expect_equal(err$must_be, '> 0')
    expect_equal(err$not, 0)

})

test_that('test invalid efficiency value raises exception ', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            efficiency = 0
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'efficiency')
    expect_equal(err$must_be, '> 0')
    expect_equal(err$not, 0)

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            efficiency = 1.01
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'efficiency')
    expect_equal(err$must_be, '<= 1')
    expect_equal(err$not, 1.01)

})

test_that('test invalid min_charge and max_charge value raises exception ', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                min_charge = c(-1, -1)
            ),
            price_from = 'price',
            min_charge_from = 'min_charge',
            capacity = 1,
            c_rate = 1,
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'min_charge')
    expect_equal(err$must_be, '>= 0')
    expect_equal(err$not, '[-1, -1]')
    expect_equal(err$comment, "Check `data` argument")

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c(-1, -1)
            ),
            price_from = 'price',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1,
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'max_charge')
    expect_equal(err$must_be, '>= 0')
    expect_equal(err$not, '[-1, -1]')
    expect_equal(err$comment, "Check `data` argument")

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c(2, 2)
            ),
            price_from = 'price',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1,
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'max_charge')
    expect_equal(err$must_be, '<= `capacity`')
    expect_equal(err$not, '[2, 2]')
    expect_equal(err$comment, "Check `data` argument")

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c(.4, 0),
                min_charge = c(.5, 0)
            ),
            price_from = 'price',
            max_charge_from = 'max_charge',
            min_charge_from = 'min_charge',
            capacity = 1,
            c_rate = 1,
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'max_charge')
    expect_equal(err$must_be, '>= `min_charge`')
    expect_equal(err$not, '[0.4]')
    expect_equal(err$comment, "Check `data` argument")
})

test_that('test invalid init_charge argument', {

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            init_charge = -1
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'init_charge')
    expect_equal(err$must_be, '>= 0')
    expect_equal(err$not, -1)

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2)
            ),
            price_from = 'price',
            capacity = 1,
            c_rate = 1,
            init_charge = 2
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'init_charge')
    expect_equal(err$must_be, '<= `capacity`')
    expect_equal(err$not, 2)

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                min_charge = c(.2, .6)
            ),
            price_from = 'price',
            min_charge_from = 'min_charge',
            capacity = 1,
            c_rate = 1,
            init_charge = .1
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'init_charge')
    expect_equal(err$must_be, '>= `min_charge[1]`')
    expect_equal(err$not, .1)

    err <- rlang::catch_cnd(
        optimise_arbitrage(
            data = data.frame(
                price = c(1, 2),
                max_charge = c(.4, .2)
            ),
            price_from = 'price',
            max_charge_from = 'max_charge',
            capacity = 1,
            c_rate = 1,
            init_charge = .5
        )
    )
    expect_s3_class(err, 'error_out_of_range')
    expect_equal(err$var, 'init_charge')
    expect_equal(err$must_be, '<= `max_charge[1]`')
    expect_equal(err$not, .5)

})

# Test expected output. ---------------------------------------------------

test_that('test expected output', {

    input_data <- data.frame(
        price = c(1, 2),
        min_charge = c(.1, .1),
        max_charge = c(.9, .9)
    )
    output <- optimise_arbitrage(
        data = input_data,
        price_from = 'price',
        capacity = 1,
        c_rate = 1,
        efficiency = 1
    )
    expect_is(output, 'data.frame')

    output_names <- c(names(input_data), 'charge_state',
                      'discharge', 'charge', 'arb_income', 'deg_cost')

    expect_setequal(names(output), output_names)
    expect_true(nrow(output) == 2)
    expect_true(all(lapply(output, class) == 'numeric'))
})

# Test no solution. -------------------------------------------------------

test_that('inputs with no solution handled', {

        # Marginal case.
        expect_error(
            optimise_arbitrage(
                data = data.frame(
                    price = c(1, 2),
                    exclude = c(0, 1),
                    max_charge = c(.5, 1),
                    min_charge = c(0, .7)
                ),
                price_from = 'price',
                exclude_from = 'exclude',
                min_charge_from = 'min_charge',
                max_charge_from = 'max_charge',
                capacity = 1,
                c_rate = 1,
                efficiency = 1,
                init_charge = .2
            ),
            NA
        )
        # Infeasible
        err <- rlang::catch_cnd(
            optimise_arbitrage(
                data = data.frame(
                    price = c(1, 2),
                    exclude = c(0, 1),
                    max_charge = c(.5, 1),
                    min_charge = c(0, .701)
                ),
                price_from = 'price',
                exclude_from = 'exclude',
                min_charge_from = 'min_charge',
                max_charge_from = 'max_charge',
                capacity = 1,
                c_rate = 1,
                efficiency = 1,
                init_charge = .2
            )
        )
        expect_s3_class(err, 'error_no_solution')
        expect_equal(err$status, 'infeasible')

        # Marginal case.
        expect_error(
            optimise_arbitrage(
                data = data.frame(
                    price = c(1, 2),
                    exclude = c(1, 0),
                    max_charge = c(.5, 1),
                    min_charge = c(0, .25)
                ),
                price_from = 'price',
                exclude_from = 'exclude',
                min_charge_from = 'min_charge',
                max_charge_from = 'max_charge',
                capacity = 1,
                c_rate = 1,
                efficiency = 1,
                init_charge = .25
            ),
            NA
        )
        # Infeasible.
        err <- rlang::catch_cnd(
            optimise_arbitrage(
                data = data.frame(
                    price = c(1, 2),
                    exclude = c(1, 0),
                    max_charge = c(.5, 1),
                    min_charge = c(0, .251)
                ),
                price_from = 'price',
                exclude_from = 'exclude',
                min_charge_from = 'min_charge',
                max_charge_from = 'max_charge',
                capacity = 1,
                c_rate = 1,
                efficiency = 1,
                init_charge = .25
            )
        )
        expect_s3_class(err, 'error_no_solution')
        expect_equal(err$status, 'infeasible')
})

# Verification unit tests -------------------------------------------------

# Verification means "are the equations right".  These tests are reviewed
# by a domain expert to ensure that the algorithm is programmed correctly.
# The test I/O is described in JSON which is fairly human readable, enabling
# the domain expert to inspect the tests setup.

# Find test files.
requireNamespace("rjson", quietly = TRUE)
dir_tests <- file.path('test-data', 'arbitrage_optimisation')
json_files <- list.files(dir_tests, pattern = "json$")

# Parse the JSON test data and combine to list of tests.
json_tests <- lapply(file.path(dir_tests, json_files),
                     function(x) rjson::fromJSON(file = x))
json_tests <- do.call(c, json_tests)

# Perform a single verification test.
run_comparison_test <- function(test) {
    test_that(test[['title']], {

        # Read input.
        input <- test[['input']]

        data <- as.data.frame(input[['data']])
        price_from <- input[['price_from']]
        if (exists('exclude_from', input)) {
            exclude_from <- input[['exclude_from']]
        } else {
            exclude_from <- NULL
        }
        if (exists('max_charge_from', input)) {
            max_charge_from <- input[['max_charge_from']]
            to_na <- data[[max_charge_from]] < 0
            data[[max_charge_from]][to_na] <- NA
        } else {
            max_charge_from <- NULL
        }
        if (exists('min_charge_from', input)) {
            min_charge_from <- input[['min_charge_from']]
            to_na <- data[[min_charge_from]] < 0
            data[[min_charge_from]][to_na] <- NA
        } else {
            min_charge_from <- NULL
        }
        capacity <- input[['capacity']]
        c_rate <- input[['c_rate']]
        if (exists('efficiency', input)) {
            efficiency <- input[['efficiency']]
        } else {
            efficiency <- 1
        }
        if (exists('t_period', input)) {
            t_period <- input[['t_period']]
        } else {
            t_period <- .5
        }
        if (exists('init_charge', input)) {
            init_charge <- input[['init_charge']]
        } else {
            init_charge <- 0
        }
        if (exists('deg_cost_per_cycle', input)) {
            deg_cost_per_cycle <- input[['deg_cost_per_cycle']]
        } else {
            deg_cost_per_cycle <- 0
        }

        # Read expected output.
        output <- as.data.frame(test[['output']])
        expected <- cbind(data, output)

        # Get actual output.
        actual <- optimise_arbitrage(
            data =                data,
            price_from =          price_from,
            exclude_from =        exclude_from,
            min_charge_from =     min_charge_from,
            max_charge_from =     max_charge_from,
            capacity =            capacity,
            c_rate =              c_rate,
            efficiency =          efficiency,
            t_period =            t_period,
            init_charge =         init_charge,
            deg_cost_per_cycle =  deg_cost_per_cycle
        )

        # Test actual and expected results are equivalent.
        expect_equivalent(actual, expected, tolerance = 0.001)

        # If total income is provided, check total income equivalance.
        if (exists('tot_income', test)) {
            actual <- actual[['arb_income']] + actual[['deg_cost']]
            expected <- test[['tot_income']]
            expect_equivalent(actual, expected, tolerance = 0.001)
        }
    })
}

# Iterate through each test.
invisible(lapply(json_tests, run_comparison_test))
