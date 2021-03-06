fact_names <- function() {
  c(
    date = "date",
    clock_mins = "clock_mins",
    clock_hour = "clock_hour",
    D = "wind_direction",
    G = "wind_gust_mph",
    H = "humidity_pct",
    P = "pressure_hpa",
    Pt = "pressure_tendency",
    Dp = "dew_pont_c",
    S = "wind_speed_mph",
    T = "temp_c",
    V = "visibility",
    F = "feels_like_temp_c",
    Pp = "precipitation_prob",
    U = "max_uv_index",
    W = "weather_type"
  )
}

numeric_fact_names <- function() {
  c(
    clock_mins = "clock_mins",
    G = "wind_gust_mph",
    H = "humidity_pct",
    P = "pressure_hpa",
    Dp = "dew_pont_c",
    S = "wind_speed_mph",
    T = "temp_c",
    F = "feels_like_temp_c",
    Pp = "precipitation_prob",
    U = "max_uv_index",
    W = "weather_type"
  )
}
