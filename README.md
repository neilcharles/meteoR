# meteoR
An R interface to the UK Met Office's forecasts and weather reports API

### Installation

```r
devtools::install_github("neilcharles/meteoR")
```

### Usage

You will need a valid Met Office API Key. Register [here](https://register.metoffice.gov.uk/WaveRegistrationClient/public/register.do?service=datapoint).

Register your api key and meteoR will save it in the current working directory.

```r
set_api_key(YOUR KEY)
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
