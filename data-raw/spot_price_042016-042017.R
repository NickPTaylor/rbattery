## code to prepare `DATASET` dataset goes here
col_spec <- readr::cols(
    timestamp = readr::col_datetime(format = "%d/%m/%Y %H:%M"),
    N2EX =      readr::col_double(),
    EPEX =      readr::col_double(),
    SSP =       readr::col_double()
)
spot_price_2016 <- readr::read_csv('data-raw/spot_price_042016-042017.csv',
                                   col_types = col_spec)

usethis::use_data(spot_price_2016, overwrite = TRUE)
