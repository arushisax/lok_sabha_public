## 1: PREPROCESSING
packages <- c(
  "tidyverse", "leaflet", "tidycensus", "mapview", "sf", "tmap", "tmaptools", 
  "tigris", "ggplot2", "viridis", "ggthemes", "gganimate", "gifski", "shinycssloaders", 
  "transformr", "shinythemes", "lubridate", "shinythemes", "rtweet", "janitor", "tidyr",
  "tidytext", "readr"
  )
lapply(packages, require, character.only = TRUE)
