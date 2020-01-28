sf_provice <- function(month, day, hour) {

    url <- paste0("http://69.171.70.18:5000/download/province_level_2020-",
                  month, "-", day, "T", hour, ".csv")

    data <- read.csv(url, fileEncoding = 'UTF-8', stringsAsFactors = FALSE) %>%
        dplyr::select(province = provinceName, confirmed = confirmedCount,
                      cured = curedCount, dead = deadCount)

    map_provice %>% dplyr::left_join(data, by = c("name" = "province")) %>%
        dplyr::mutate(confirmed = dplyr::coalesce(confirmed, 0L),
                      cured = dplyr::coalesce(cured, 0L),
                      dead = dplyr::coalesce(dead, 0L)) %>%
        dplyr::select(adcode, name, confirmed, cured, dead)
}


