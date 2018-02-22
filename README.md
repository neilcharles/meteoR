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

sites <- forecast_get_site(site_id)
```
