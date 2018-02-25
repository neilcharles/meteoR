add_weather_descriptions <- function(weather){

  weather_type_descriptions <- readr::read_rds("data/weather_type_lookup.RDS")
  visibility_descriptions <- readr::read_rds("data/visibility_lookup.RDS")

  weather %>%
    dplyr::left_join(weather_type_descriptions, by = "weather_type") %>%
    dplyr::left_join(visibility_descriptions, by = "visibility")

}
