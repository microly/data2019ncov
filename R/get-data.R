#' sf_provice
#'
#' get the 2019-nCov data at provincial level
#'
#' @param month a integer
#' @param day a integer
#' @param hour a integer
#'
#' @return a sf object
#' @importFrom purrr possibly
#' @importFrom dplyr select left_join mutate
#' @export
#'
#' @examples
#' \dontrun{
#' get the 2019-nCov data at provincial level at the time: 20:00, January 29.
#' sf_provice(month = 1, day = 29, hour = 20)
#' }
sf_provice <- function(month, day, hour) {

    month <- good_char(month)
    day <- good_char(day)
    hour <- good_char(hour)

    url <- paste0("http://69.171.70.18:5000/download/province_level_2020-",
                  month, "-", day, "T", hour, ".csv")

    data <- possibly(readr::read_csv, NA)(url)

    if (!is.data.frame(data)) {
        warning(paste0("month: ", month, ", day: ", day,
                                 " , hour: ", hour,
                                 ", get no data, return NA!"))
        return(NA)
    }

    data <- dplyr::select(data, province = provinceName,
                          confirmed = confirmedCount,
                          cured = curedCount, dead = deadCount)

    map_provice %>% dplyr::left_join(data, by = c("name" = "province")) %>%
        dplyr::mutate(confirmed = dplyr::coalesce(confirmed, 0),
                      cured = dplyr::coalesce(cured, 0),
                      dead = dplyr::coalesce(dead, 0)) %>%
        dplyr::select(adcode, name, confirmed, cured, dead)
}


#' sf_prefecture_city
#'
#' get the 2019-nCov data at the prefecture city level
#'
#' @param month a integer
#' @param day a integer
#' @param hour a integer
#'
#' @return a sf object
#' @export
#' @importFrom sf read_sf st_contains
#' @importFrom purrr map_dbl
#' @importFrom dplyr mutate bind_cols select
#' @examples
#' \dontrun{
#' # get the 2019-nCov data at the prefecture city level at the time: 20:00, January 29.
#' sf_prefecture_city(month = 1, day = 29, hour = 20)
#' }
sf_prefecture_city <- function(month, day, hour) {

    month <- good_char(month)
    day <- good_char(day)
    hour <- good_char(hour)

    url <- paste0("http://69.171.70.18:5000/data/point/city_level_2020-",
                  month, "-", day, "T", hour, ".geojson")

    data <- purrr::possibly(sf::read_sf, NA)(url)

    if (!inherits(data, "sf")) {
        warning(paste0("month: ", month, ", day: ", day,
                       " , hour: ", hour,
                       ", get no data, return NA!"))
        return(NA)
    }

    sgbp <- sf::st_contains(map_city, data)
    class(sgbp) <- NULL

    df_data <- data.frame(sgbp = I(sgbp)) %>%
        mutate(confirmed = map_dbl(sgbp, ~get_sum(., data, "city.confirmedCount")),
                      cured = map_dbl(sgbp, ~get_sum(., data, "city.curedCount")),
                      dead = map_dbl(sgbp, ~get_sum(., data, "city.deadCount")))

    bind_cols(map_city, df_data) %>%
        select(adcode, name, confirmed, cured, dead)
}


# helper function for sf_prefecture_city
get_sum <- function(id, data, col) {
    if (length(id) == 0) return(0)
    sum(data[[col]][id])
}

# helper function for input
good_char <- function(x) {
    x <- as.character(x)
    if (nchar(x) == 1) x <- paste0("0", x)
    x
}

