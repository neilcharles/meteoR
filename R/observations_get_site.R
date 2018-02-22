#' Retrieve hourly site observations for the past 24 hours
#'
#' Requests observations from the met office API in xml format and returns a \code{tibble}
#' @param site_id a valid met office observations site id. Use \code{observations_list_sites()} to get ID numbers.
#' @export
#' @examples
#' observations_get_site(3840)
#' @importFrom magrittr %>%
observations_get_site <- function(site_id){
  xml_data <- xml2::read_xml(paste0(
    api_root(),
    "val/wxobs/all/xml/",
    site_id,
    "?res=hourly",
    "&key=",
    read_api_key()
  ))

  df <- tibble::tibble(xml = rvest::xml_nodes(xml_data, "Period")) %>%
    dplyr::mutate(date = as.Date(as.character(purrr::map(xml, .f = ~xml2::xml_attrs(.)[2])))) %>%  #pull date
    dplyr::mutate(xml_obs = purrr::map(xml, .f = ~rvest::xml_nodes(., "Rep"))) %>% #pull obs as awkward list
    dplyr::mutate(clock_mins = purrr::map(xml_obs, .f = ~xml2::xml_text(xml2::xml_contents(.)))) %>% #get obs clock
    dplyr::mutate(obs = purrr::map(xml_obs, .f = ~dplyr::bind_rows(purrr::map(xml2::xml_attrs(.), .f = ~tibble::as.tibble(t((.))))))) %>%  #reformat obs as nested tibbles
    dplyr::mutate(obs = purrr::map2(obs, clock_mins, .f = ~add_clock(.x, .y))) %>%
    dplyr::select(date, obs) %>%
    tidyr::unnest() %>%
    dplyr::select(date, clock_mins, dplyr::everything())

  names(df) <- fact_names()[names(df)]

  df

}
