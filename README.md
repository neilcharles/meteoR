# meteoR
An R interface to the UK Met Office's Datapoint forecasts and weather reports API

### Installation

```r
devtools::install_github("neilcharles/meteoR")
```

### Usage

You will need a valid Met Office API Key. Register [here](https://register.metoffice.gov.uk/WaveRegistrationClient/public/register.do?service=datapoint).

Use save_api_key() to store your api key in the current working directory. Calls for data will use the credentials stored in this file.

```r
save_api_key(YOUR KEY)
```

Request the list of available forecast locations.

```r
sites <- forecast_list_sites()
```

Get a five day (three hourly) forecast for a location from the sites list.

```r
site_id <- sites$id[10]

weather_forecast <- forecast_get_site(site_id)
```
A subset of sites report hourly observations for the past 24 hours. Format for the request is similar but the returned columns differ and may also be different by site. E.g. some sites don't report wind gust speed.

Request the list of available 24 hour observation locations.

```r
sites <- observations_list_sites()
```

Get the past 24 hours' observations.

```r
site_id <- sites$id[10]

weather_obs <- observations_get_site(site_id)
```

The Met Office Datapoint API uses site codes for forecast locations so meteoR includes a helper function to find the closest forecast or observation site codes for any lat long point.

This command will return the closest five observation locations to central Leeds.

```r
find_closest_site(lat = 53.8059821, long = -1.6057714, observations = TRUE, site_count = 5)
```
