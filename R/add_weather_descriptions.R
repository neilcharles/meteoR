add_weather_descriptions <- function(weather){

  weather %>%
    dplyr::left_join(weather_type_descriptions, by = "weather_type") %>%
    dplyr::left_join(visibility_descriptions, by = "visibility")

}
