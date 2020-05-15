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

  xml_nodes <- rvest::xml_nodes(xml_data, "Period")
  
  weather <- purrr::map_df(xml_nodes, function(x) {
    
    kids <- xml2::xml_children(x)
    
    kids_data <- purrr::map_df(kids,function(y){
      as.data.frame(t(xml2::xml_attrs(y)))
    }) %>% 
      dplyr::mutate(clock_mins = xml2::xml_text(kids)) %>% 
      dplyr::mutate(clock_hour = as.numeric(clock_mins)/60) %>% 
      dplyr::mutate(date = as.Date(xml2::xml_attrs(x)[2],"%Y-%m-%dZ"))
    
    return(kids_data)
  }) %>% 
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
