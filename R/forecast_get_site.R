#' Retrieve the 5 day weather forecast for a site
#'
#' Requests three-hourly forecast from the met office API in xml format and returns a \code{tibble}
#' @param site_id a valid met office site id. Use \code{forecast_list_sites()} to get ID numbers.
#' @export
#' @examples
#' forecast_get_site(3840)
#' @importFrom magrittr %>%
forecast_get_site <- function(site_id){

  check_saved_api_key()

  xml_data <- xml2::read_xml(paste0(
    api_root(),
    "val/wxfcs/all/xml/",
    site_id,
    "?res=3hourly",
    "&key=",
    read_api_key()
  ))

  weather <- tibble::tibble(xml = rvest::xml_nodes(xml_data, "Period")) %>%
    dplyr::mutate(date = as.Date(as.character(purrr::map(xml, .f = ~xml2::xml_attrs(.)[2])))) %>%  #pull date
    dplyr::mutate(xml_obs = purrr::map(xml, .f = ~rvest::xml_nodes(., "Rep"))) %>% #pull obs as awkward list
    dplyr::mutate(clock_mins = purrr::map(xml_obs, .f = ~xml2::xml_text(xml2::xml_contents(.)))) %>% #get obs clock
    dplyr::mutate(obs = purrr::map(xml_obs, .f = ~dplyr::bind_rows(purrr::map(xml2::xml_attrs(.), .f = ~tibble::as.tibble(t((.))))))) %>%  #reformat obs as nested tibbles
    dplyr::mutate(obs = purrr::map2(obs, clock_mins, .f = ~add_clock(.x, .y))) %>%
    dplyr::select(date, obs) %>%
    tidyr::unnest(cols = c(obs)) %>%
    dplyr::mutate(clock_hour = as.numeric(clock_mins) / 60) %>%
    dplyr::select(date, clock_mins, clock_hour, dplyr::everything())

  #convert abbreviations to friendly names. NOTE ALL COLUMN NAMES MUST BE IN fact_names()!!
  names(weather) <- fact_names()[names(weather)]

  #set numeric column types
  suppressWarnings({
    weather <- weather %>%
    dplyr::mutate_at(dplyr::vars(dplyr::one_of(numeric_fact_names())), as.numeric)
  })

  #Add descriptive columns
  weather <- add_weather_descriptions(weather)

  weather

}
