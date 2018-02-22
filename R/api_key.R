#' Register a Met Office API key to make requests
#'
#' Saves a .rds format file in the current working directory to store API credentials. All API functions will fail until you have done this!
#' Register for a new key here: https://register.metoffice.gov.uk/WaveRegistrationClient/public/register.do?service=datapoint
#' @param api_key a valid met office api key
#' @export
#' @examples
#' save_api_key(your valid key)
save_api_key <- function(api_key) {
  readr::write_rds(api_key, "api_key")
}

read_api_key <- function(){
  readr::read_rds("api_key")
}

api_root <- function(){
  "http://datapoint.metoffice.gov.uk/public/data/"
}
