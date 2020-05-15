#' List available locations for forecasts
#'
#' Requests locations from the met office API in xml format and returns a \code{tibble}
#' @export
#' @examples
#' forecast_list_sites()
#' @importFrom magrittr %>%
forecast_list_sites <- function() {

  check_saved_api_key()

  xml_data <- xml2::read_xml(paste0(
    api_root(),
    "val/wxfcs/all/xml/sitelist?res=daily",
    "&key=",
    read_api_key()
  ))
  
  xml_nodes <- rvest::xml_nodes(xml_data, "Location")
  
  sites <- purrr::map_df(xml_nodes, function(x) {
      as.data.frame(t(xml2::xml_attrs(x)))
    }) %>%
    dplyr::mutate_at(dplyr::vars(c("elevation", "latitude", "longitude")), as.numeric) %>% 
    as_tibble()
  
  sites
}
