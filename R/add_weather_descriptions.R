add_weather_descriptions <- function(weather){

  weather %>%
    dplyr::left_join(weather_type_lookup, by = "weather_type") %>%
    dplyr::left_join(visibility_lookup, by = "visibility")

}
