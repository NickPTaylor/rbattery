#' Electricity Market Spot Prices for April 2016 - April 2017
#'
#' A dataset containing a year of electricity spot prices for the N2EX, EPEX and
#' SSP markets.
#'
#' @format A dataframe with 17558 rows and 4 variables:
#' \describe{
#'   \item{\code{timestamp}}{Date and time (UTC) at beginning of settlement
#'     each period.}
#'   \item{\code{N2EX}}{N2EX market spot price for settlement period, £/MWh.}
#'   \item{\code{EPEX}}{EPEX market spot price for settlement period, £/MWh.}
#'   \item{\code{SSP}}{SSP market spot price for settlement period, £/MWh.}
#' }
"spot_price_2016"

#' Australian Electricity Market Spot Prices for July 2017 - June 2018
#'
#' A dataset containing a year of electricity spot prices for the Australian
#' market.
#'
#' @format A dataframe with 17520 rows and 2 variables:
#' \describe{
#'   \item{\code{timestamp}}{Local date and time at beginning of each
#'   settlement period.}
#'   \item{\code{price}}{Spot price for settlement period, £/MWh.}
#' }
"spot_price_au_2017"

#' UK Electricity Market Spot Prices for October 2018 - September 2019
#'
#' A dataset containing a year of electricity spot prices for the UK market.
#'
#' @format A dataframe with 17520 rows and 2 variables:
#' \describe{
#'   \item{\code{timestamp}}{Local date and time at beginning of each
#'   settlement period.}
#'   \item{\code{price}}{Spot price for settlement period, £/MWh.}
#' }
"spot_price_uk_2018"