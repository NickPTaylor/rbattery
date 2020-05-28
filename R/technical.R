#' Calculate battery power
#'
#' \code{get_power} returns the battery power given capacity and charge
#'     rate.
#'
#' @param capacity numeric scalar, the battery capacity.
#' @param c_rate numeric scalar, the battery charge rate.
#'
#' @return Returns a numeric scalar, the battery power.
#' @export
#'
#' @example inst/examples/technical/get_power.R
#'
get_power <- function(capacity, c_rate) {
    stopifnot(is.numeric(capacity), is.numeric(c_rate))
    if (!(capacity > 0)) {
        stop("capacity must be greater than 0")
    }
    if (!(c_rate > 0)) {
        stop("c_rate must be greater than 0")
    }
    capacity * c_rate
}
