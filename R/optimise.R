utils::globalVariables(c("i", "j", "op_mode", "charge_state"))

#' Optimise income from arbitrage
#'
#' \code{optimise_arbitrage} maximises the income from a battery storage
#' solution by using a linear programming based optimisation.
#'
#' The arbitrage market involves charging the battery when the price of
#' electricity is low and discharging when it is high. The amount of energy that
#' the battery can store is limited by its capacity.  The charge rate is the
#' battery power normalised by capacity. For example, a battery with a:
#'
#' \itemize{
#'   \item Charge rate of 1 will fully charge/discharge in 1 hour.
#'   \item Charge rate of 2 will fully charge/discharge in 30 minutes.
#'   \item Charge rate of .5 will fully charge/discharge in 2 hours.
#' }
#'
#' The efficiency of the battery will impact the profitability of
#' charging/discharging since a certain amount of energy is lost as heat during
#' the process with comes at a cost.
#'
#' The battery degrades as it is used.  In this simple model, a degradation
#' cost per charge/discharge cycle is assumed i.e. \code{deg_cost_per_cycle}.
#' For each settlement period, the cost of degradation is calculated based on
#' the proportion of a charge/discharge cycle occurring in the period.
#'
#' Optionally, the \code{exclude_from} column of \code{data} can be used to
#' control whether settlement periods should be excluded from arbitrage
#' optimisation.  If the value is \code{TRUE}, the settlement period will be
#' excluded from arbitrage, or \code{FALSE} otherwise.
#'
#' Optionally, the \code{max_charge_from} and/or \code{min_charge_from} columns
#' of \code{data} can be supplied.  If these arguments are not provided, then
#' for every settlement period, the minimum charge will be zero and the maximum
#' charge will be the value provided by the \code{capacity} argument.  If
#' \code{max_charge_from} and/or \code{min_charge_from} are set, then values
#' specify the maximum and minimum charge, respectively, at the beginning of
#' the corresponding settlement period.  Any value that is \code{NA} is
#' default to be zero for the minimum charge and the value provided by the
#' \code{capacity} argument for the maximum charge.
#'
#' @param data data frame, with a row for each settlement period and columns
#' for:
#'   \describe{
#'     \item{Spot Price.}{Numeric, mandatory.  Electricity spot price for each
#'       settlement period.}
#'     \item{Excluded Settlement Periods.}{Logical, optional.  Should the
#'       settlement period be excluded from arbitrage optimisation?}
#'     \item{Minimum Charge.}{Numeric, optional.  Minimum charge at beginning
#'       of settlement period.}
#'     \item{Maximum Charge.}{Numeric, optional.  Maximum charge at beginning
#'       of settlement period.}
#'  }
#' @param price_from string.  Name of column in \code{data} which refers to
#'   the spot price.
#' @param exclude_from string. Name of column in \code{data} which refers to
#'   excluded settlement periods, if applicable.
#' @param min_charge_from string.  Name of column in \code{data} which refers
#'   to minimum charge, if applicable.
#' @param max_charge_from string.  Name of column in \code{data} which refers
#'   to maximum charge, if applicable.
#' @param capacity numeric scalar, battery capacity.
#' @param c_rate numeric scalar, battery charge rate.
#' @param efficiency numeric scalar, charge/discharge efficiency of battery.
#' @param t_period numeric scalar, duration of a settlement period.
#' @param init_charge numeric scalar, initial charge on battery.
#' @param deg_cost_per_cycle numeric scalar, degradation cost per complete
#'   charge/discharge cycle.
#'
#' @return Returns a data.frame with the same data as the \code{data} argument,
#'   as well additional data describing the battery operation for optimal
#'   arbitrage income.  The battery operation data is:
#'   \describe{
#'     \item{\code{charge_state}}{numeric, the state of charge at the beginning
#'       of the settlement period for optimal arbitrage.}
#'     \item{\code{discharge}}{numeric, the proportion of the settlement period
#'       that the battery should discharge for optimal arbitrage.}
#'     \item{\code{charge}}{numeric, the proportion of the settlement period
#'       that the battery should charge for optimal arbitrage.}
#'     \item{\code{opt_arb}}{numeric, income during settlement period for
#'       optimal arbitrage.}
#'     \item{\code{deg_cost}}{numeric, cost of degradation during settlement
#'       period.}
#'   }
#'
#' @import ROI.plugin.symphony
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @example inst/examples/optimise/optimise_arbitrage.R
#'
optimise_arbitrage <- function(data, price_from, exclude_from = NULL,
                               max_charge_from = NULL, min_charge_from = NULL,
                               capacity, c_rate, efficiency = 1, t_period = .5,
                               init_charge = 0, deg_cost_per_cycle = 0) {

    N <- nrow(data)   # <--- Number of settlement periods.

    # Check arguments. ----------------------------------------------------

    # Check type and interpret arguments.
    if (!is.data.frame(data)) {
        abort_bad_argument_type(data, must_be = 'data.frame')
    }
    if (!(nrow(data) > 1)) {
        abort_bad_shape(data, FUN = nrow, must_be = "> 1")
    }

    if (!is.numeric(capacity)) {
        abort_bad_argument_type(capacity, must_be = 'numeric')
    }

    if (!is.numeric(c_rate)) {
        abort_bad_argument_type(c_rate, must_be = 'numeric')
    }

    if (!is.numeric(efficiency)) {
        abort_bad_argument_type(efficiency, must_be = 'numeric')
    }

    if (!is.numeric(t_period)) {
        abort_bad_argument_type(t_period, must_be = 'numeric')
    }

    if (!is.numeric(init_charge)) {
        abort_bad_argument_type(init_charge, must_be = 'numeric')
    }

    if (!is.character(price_from)) {
        abort_bad_argument_type(price_from, must_be = 'character')
    }
    if (!price_from %in% names(data)) {
        abort_bad_name(price_from, not_in_df = data)
    }
    price = data[[price_from]]
    if (!is.numeric(price)) {
        abort_bad_column_type(price_from, in_df = data, must_be = 'numeric')
    }

    if (!is.null(exclude_from)) {
        if (!is.character(exclude_from)) {
            abort_bad_argument_type(exclude_from, must_be = 'character')
        }
        if (!exclude_from %in% names(data)) {
            abort_bad_name(exclude_from, not_in_df = data)
        }
        exclude <- data[[exclude_from]]
        if (!(is.logical(exclude) || is.numeric(exclude))) {
            abort_bad_column_type(exclude_from, in_df = data,
                                  must_be = 'logical or numeric')
        }
        exclude <- as.logical(exclude)
    } else {
        exclude <- rep_len(FALSE, N)
    }

    if (!is.null(min_charge_from)) {
        if (!is.character(min_charge_from)) {
            abort_bad_argument_type(min_charge_from, must_be = 'character')
        }
        if (!min_charge_from %in% names(data)) {
            abort_bad_name(min_charge_from, not_in_df = data)
        }
        min_charge <- data[[min_charge_from]]
        if (!is.numeric(min_charge)) {
            abort_bad_column_type(min_charge_from, in_df = data,
                                  must_be = 'numeric')
        }
        min_charge[is.na(min_charge)] <- 0
    } else {
        min_charge <- rep_len(0, N)
    }

    if (!is.null(max_charge_from)) {
        if (!is.character(max_charge_from)) {
            abort_bad_argument_type(max_charge_from, must_be = 'character')
        }
        if (!max_charge_from %in% names(data)) {
            abort_bad_name(max_charge_from, not_in_df = data)
        }
        max_charge <- data[[max_charge_from]]
        if (!is.numeric(max_charge)) {
            abort_bad_column_type(max_charge_from, in_df = data,
                                  must_be = 'numeric')
        }
        max_charge[is.na(max_charge)] <- capacity
    } else {
        max_charge <- rep_len(capacity, N)
    }

    # Check valid values. -------------------------------------------------

    if (!(capacity > 0)) {
        abort_out_of_range('capacity', must_be = "> 0", not = capacity)
    }
    if (!(c_rate > 0)) {
        abort_out_of_range('c_rate', must_be = "> 0", not = c_rate)
    }
    if (!(t_period > 0)) {
        abort_out_of_range('t_period', must_be = "> 0", not = t_period)
    }
    if (!efficiency > 0) {
        abort_out_of_range('efficiency', must_be = "> 0", not = efficiency)
    }
    if (!efficiency <= 1) {
        abort_out_of_range('efficiency', must_be = "<= 1", not = efficiency)
    }

    # Check max/min charge.
    if (!all(min_charge >= 0)) {
        not = paste(utils::head(min_charge[!(min_charge >= 0)]), collapse = ", ")
        not <- glue::glue("[{not}]")
        abort_out_of_range('min_charge', must_be = ">= 0", not = not,
                           comment = "Check `data` argument")
    }
    if (!all(max_charge >= 0)) {
        not = paste(utils::head(max_charge[!(max_charge >= 0)]),collapse = ", ")
        not <- glue::glue("[{not}]")
        abort_out_of_range('max_charge', must_be = ">= 0", not = not,
                           comment = "Check `data` argument")
    }
    if (!all(max_charge <= capacity)) {
        not = paste(utils::head(max_charge[!(max_charge <= capacity)]),
                    collapse = ", ")
        not <- glue::glue("[{not}]")
        abort_out_of_range('max_charge', must_be = "<= `capacity`", not = not,
                           comment = "Check `data` argument")
    }
    if (!all(max_charge >= min_charge)) {
        not = paste(utils::head(max_charge[!(max_charge >= min_charge)]),
                    collapse = ", ")
        not <- glue::glue("[{not}]")
        abort_out_of_range('max_charge', must_be = ">= `min_charge`",
                           not = not, comment = "Check `data` argument")
    }

    # Check init_charge.
    if (!init_charge >= 0) {
        abort_out_of_range('init_charge', must_be = ">= 0", not = init_charge)
    }
    if (!init_charge <= capacity) {
        abort_out_of_range('init_charge', must_be = "<= `capacity`",
                           not = init_charge)
    }
    if (!init_charge >= min_charge[1]) {
        abort_out_of_range('init_charge', must_be = ">= `min_charge[1]`",
                           not = init_charge)
    }
    if (!init_charge <= max_charge[1]) {
        abort_out_of_range('init_charge', must_be = "<= `max_charge[1]`",
                           not = init_charge)
    }

    # Optimisation model. -------------------------------------------------

    power <- get_power(capacity, c_rate)

    # Instantiate  model.
    model <- ompr::MILPModel()

    # Model variables.
    #
    # 1) op_mode:
    #    Proportion of time spent in each operation mode.
    #    j = 1 is is discharge, j = 2 is charge.
    #
    # 2) charge_state:
    #    Charge state of battery at beginning of period.
    model <- model %>%
        ompr::add_variable(op_mode[i, j], i = 1:N, j = 1:2, lb = 0, ub = 1,
                     type = 'continuous') %>%
        ompr::add_variable(charge_state[1:N], lb = 0, ub = capacity,
                     type = 'continuous')

    # Model constraints.
    #
    # 1) charge_state == init_charge at beginning of first settlement period.
    # 2) charge_state <= max_charge for each settlement period.
    # 3) charge_state >= min_charge for each settlement period.
    # 4) charge_state equal at settlement at settlement period end/start.
    # 5) charge_state <= capacity at end of final settlement period.
    # 6) charge_state >= 0 at end of final settlement period.
    # 7) If period is included in arbitrage, the sum of the proportion of
    #    periods for each operation mode <= 1.
    #    If period is excluded from arbitrage, each operation mode == 0.
    model <- model %>%
        ompr::add_constraint(charge_state[1] == init_charge) %>%
        ompr::add_constraint(charge_state[2:N] <= max_charge[2:N]) %>%
        ompr::add_constraint(charge_state[2:N] >= min_charge[2:N]) %>%
        ompr::add_constraint(
            charge_state[i] - charge_state[i - 1] ==
                power * t_period * (op_mode[i - 1, 2] -  op_mode[i - 1, 1]),
            i = 2:N) %>%
        ompr::add_constraint(
            charge_state[N] +
                (power * t_period) *
                (op_mode[N, 2] - op_mode[N, 1]) >= 0) %>%
        ompr::add_constraint(
            charge_state[N] +
                (power * t_period) *
                (op_mode[N, 2] - op_mode[N, 1]) <=  capacity)

    if (any(exclude)) {
        model <- model %>%
            ompr::add_constraint(op_mode[i, j] == 0, i = 1:N, j = 1:2,
                                 exclude[i])
    }
    if (any(!exclude)) {
        model <- model %>%
             ompr::add_constraint(op_mode[i, ompr::colwise(1:2)] <= 1, i = 1:N,
                                  !exclude[i])
    }

    # Model objective - maximise income.
    model <- model %>%
        ompr::set_objective(
            price *
                (efficiency**2 * op_mode[1:N, 1] - op_mode[1:N, 2])
            - efficiency * deg_cost_per_cycle *
                (op_mode[1:N, 1] + op_mode[1:N, 2]) / (2 * capacity),
            sense = 'max')

    # Solve optimisation. -------------------------------------------------

    # Solve model.
    solution <- model %>% ompr::solve_model(ompr.roi::with_ROI('symphony'))
    status <- solution %>% ompr::solver_status()
    if ((status) != 'optimal') abort_no_solution(status)

    # Calculate results to original data and return. ----------------------
    data <- cbind(data, make_df_opt_arb(solution))
    data[['arb_income']] <- c_rate * capacity * t_period * price *
        (data[['discharge']] * efficiency - data[['charge']]/efficiency)
    data[['deg_cost']] <- -c_rate * capacity * t_period * deg_cost_per_cycle *
        ((data[['discharge']] + data[['charge']])/(2 * capacity))

    data
}

make_df_opt_arb <- function(solution) {

    # Get charge state solution
    charge_state <- solution %>%
        ompr::get_solution(charge_state[i])

    charge_state <- charge_state[['value']]

    # Get operation model solution.
    op_mode <- solution %>%
        ompr::get_solution(op_mode[i, j])
    discharge <- op_mode[op_mode[['j']] == 1, 'value']
    charge <- op_mode[op_mode[['j']] == 2, 'value']

    data.frame(charge_state, discharge, charge)
}
