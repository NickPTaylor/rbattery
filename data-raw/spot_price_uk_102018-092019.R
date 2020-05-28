## code to prepare `DATASET` dataset goes here
file_name <- file.path('data-raw', 'spot_price_uk_102018-092019.csv')
col_spec <- readr::cols(
    `Date and Time` = readr::col_datetime(format = "%Y/%m/%d %H:%M"),
    Period          = readr::col_skip(),
    Price           = readr::col_double()
)
spot_price_uk_2018 <-
    readr::read_csv(file_name, col_types = col_spec,
                    locale = readr::locale(tz = "Europe/London"))
spot_price_uk_2018 <-
    dplyr::rename(spot_price_uk_2018,
                  timestamp = `Date and Time`,
                  price = Price)

usethis::use_data(spot_price_uk_2018, overwrite = TRUE)
