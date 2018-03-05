#' Find the closest forecast or observations site to an arbitrary lat long point.
#'
#' Calls either \code{forecast_list_sites()} or \code{observations_list_sites()} and returns the closest site to any lat long point.
#' @param lat Decimal latitude
#' @param long Decimal longitude
#' @param observations \code{Boolean}. \code{FALSE} (default) returns a forecast location. \code{TRUE} returns a past 24 hour observations location.
#' @param site_count Number of sites to return. Defaults to 1 but may be increased if data from the closest site presents problems.
#' @param cached_sites Optionally pass output from a \code{forecast_list_sites()} call or \code{observations_list_sites()} to the function. If not included, a site list will be requested from the api.
#' @export
#' @examples
#' find_closest_site(lat = 53.8059821, long = -1.6057714, observations = TRUE, site_count = 5)
#' @importFrom magrittr %>%
find_closest_site <- function(lat, long, observations = FALSE, site_count = 1, cached_sites = NULL) {

  if(!is.null(cached_sites)){
    sites <- cached_sites
  } else{

    if (observations) {
      sites <- observations_list_sites()
    } else {
      sites <- forecast_list_sites()
    }
  }

  sites_distance <- sites %>%
    dplyr::rowwise() %>%
    dplyr::mutate(distance = geosphere::distGeo(c(longitude, latitude), c(long, lat))) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(distance) %>%
    dplyr::top_n(site_count, -distance)

  sites_distance

}
