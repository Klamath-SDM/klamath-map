library(tidyverse)
library(shiny)
library(leaflet)
library(sf)
library(janitor)
library(klamathWaterData)
library(rivermile)
library(klamathFishData)
#library(shinyauthr)

#source("funcs.R")
#source("modules/monitoring_module.R")
#source("modules/reference_module.R")

#readRenviron(".Renviron")

# Set up aws bucket - note that login is required in order to connect to aws
processed_data_board <- pins::board_s3(bucket = "klamath-sdm", region = "us-east-1", prefix = "water_quality/processed-data/")

# function to assign sub-basin to datasets #TODO let's consider moving this function to an R package(?)
assign_sub_basin <- function(data, sub_basin, is_point = TRUE, lon_col = "longitude", lat_col = "latitude", sub_basin_col = "NAME") {
  if (is_point) {
    sf_data <- st_as_sf(data, coords = c(lon_col, lat_col), crs = 4326)
    } else {
      sf_data <- st_as_sf(data)  
      }
  sf_data <- sf_data |> 
    st_transform(st_crs(sub_basin)) |> 
    st_join(sub_basin[sub_basin_col]) |> 
    rename(sub_basin = !!sub_basin_col)
  if (is_point) {
    coords <- st_coordinates(sf_data)
    sf_data[[lon_col]] <- coords[, 1]
    sf_data[[lat_col]] <- coords[, 2]
    sf_data <- st_drop_geometry(sf_data)
    }
  return(sf_data)
  }


###############
# DATA IMPORTS 
###############

### Klamath basin outline ### ----
kl_basin_outline <- st_read("data-raw/klamath_basin_outline/R8_FAC_Klamath_Basin_WFL1.shp")
kl_basin_outline <- st_transform(kl_basin_outline, crs = 4326)

### Sub-basin boundaries #### ----
sub_basin <- st_read("data-raw/sub-basin-boundaries/Klamath_HUC8_Subbasin.shp")

sub_basin <- st_transform(sub_basin, crs = 4326)

### Basin stream lines ### ----
streams <- st_read("data-raw/klamath_basin_river_lines/Merged_Rivers.shp")
streams <- st_transform(streams, crs = 4326)

### Temperature and flow data ### ----
flow_data <- klamathWaterData::flow_data |> 
  glimpse()

flow_gage <- klamathWaterData::flow_gage |> 
  glimpse()


flow <- flow_data |> 
  inner_join(flow_gage, by = c("gage_id", "gage_name", "stream")) |> 
  group_by(stream, gage_id, gage_name, agency, latitude, longitude) |> 
  summarise(min_date = min(date), max_date = max(date)) |> 
  mutate(data_type = "flow") |> 
  assign_sub_basin(sub_basin) |>
  filter(!is.na(longitude)) |> 
  relocate(sub_basin, data_type, .before = gage_id) |> 
  glimpse()

# temperature
temperature_data <- klamathWaterData::temperature_data |> 
  glimpse()

temperature_gage <- klamathWaterData::temperature_gage |> 
  glimpse()

temperature <- temperature_data |> 
  inner_join(temperature_gage, by = c("gage_id", "gage_name", "stream")) |> 
  group_by(stream, gage_id, gage_name, agency, latitude, longitude) |> 
  summarise(min_date = min(date), max_date = max(date)) |> 
  mutate(data_type = "temperature") |> 
  assign_sub_basin(sub_basin) |>
  filter(!is.na(longitude)) |> 
  relocate(sub_basin, data_type, .before = gage_id) |> 
  glimpse()

### DO and pH ----
# Pulling data from klamathWaterData
do_data <- klamathWaterData::do_data

do_gage <- klamathWaterData::do_gage 

do <- do_data |> 
  inner_join(do_gage, by = c("gage_id", "gage_name", "stream")) |> 
  group_by(stream, gage_id, gage_name, agency, latitude, longitude) |> 
  summarise(min_date = min(date), max_date = max(date)) |> 
  mutate(data_type = "dissolved oxygen") |> 
  assign_sub_basin(sub_basin) |>
  filter(!is.na(longitude)) |> 
  relocate(sub_basin, data_type, .before = gage_id) |> 
  glimpse()

## pH data - #TODO add stream name to all datasets
ph_data <- klamathWaterData::ph_data 

ph_gage_new <- klamathWaterData::ph_gage 

ph <- ph_data |> 
  inner_join(ph_gage, by = c("gage_id", "gage_name", "stream")) |> 
  group_by(stream, gage_id, gage_name, agency, latitude, longitude) |> 
  summarise(min_date = min(date), max_date = max(date)) |> 
  mutate(data_type = "ph") |> 
  assign_sub_basin(sub_basin) |>
  filter(!is.na(longitude)) |> 
  relocate(sub_basin, data_type, .before = gage_id) |> 
  glimpse()

### RST data  ----
rst_sites <- klamathFishData::rst_sites |> glimpse()


### Habitat extent data ----
habitat_data <- klamathFishData::habitat_data |> glimpse()

### Hatcheries ----
hatcheris_new <- klamathFishData::hatcheries |> glimpse()


### Redd and Carcass Surveys ### ----
## Survey Lines
# These line shapefiles were manually created in arcgis to represent the survey extents
# shapefile 1 ---
survey_shapefile_1 <- st_read("data-raw/redd_carcass_survey/shapefiles/redd_survey_coho_USFWS.shp") 
survey_shapefile_1 <- st_transform(survey_shapefile_1, crs = 4326) 
#metadata of those on shapefiles
survey_lines_metadata_1 <- read_csv(here::here('data-raw','redd_carcass.csv')) |>
  clean_names() |>
  filter(id >= 1 & id <= 7) |> 
  select(-c(upstream_google_earth, upstream_rkm, downstream_google_earth, 
            downstream_lat, downstream_long, upstream_lat, upstream_long)) |>
  mutate(Id = id) |> 
  select(-id) |> 
  # select(-c(upstream_lat, upstream_long, downstream_long, downstream_lat, data_type)) |>
  # filter(!is.na(latitude)) |>
  mutate(species = "coho salmon and fall chinook salmon") |>   #adding this for now to include both reaches as one (id 8-13 too)
  glimpse()
# join shapefile and metadata
survey_lines_1 <- survey_shapefile_1 |> 
  left_join(survey_lines_metadata_1, by = "Id") |> 
  mutate(stream = paste(watershed, "River")) |>
  assign_sub_basin(sub_basin, is_point = FALSE) |> 
  select(-watershed) |> 
  glimpse()

print(st_crs(survey_shapefile_1))
print(st_geometry_type(survey_shapefile_1))

# shapefile 2 ---
survey_shapefile_2 <- st_read("data-raw/redd_carcass_survey/shapefiles/redd_carcass_fall_chinook.shp") |> select(-Shape_Leng)
survey_shapefile_2 <- st_transform(survey_shapefile_2, crs = 4326)
#metadata of those on shapefiles
survey_lines_metadata_2 <- read_csv(here::here('data-raw','redd_carcass.csv')) |>
  clean_names() |>
  filter(id >= 18 & id <= 20) |> 
  select(-c(upstream_google_earth, upstream_rkm, downstream_google_earth, 
            downstream_lat, downstream_long, upstream_lat, upstream_long)) |>
  mutate(Id = id,
         temporal_coverage = ifelse(temporal_coverage == "Oct 7 - Late Nov/Early Dec 2024", "2024", temporal_coverage)) |> 
  select(-id) |> 
  # select(-c(upstream_lat, upstream_long, downstream_long, downstream_lat, data_type)) |>
  # filter(!is.na(latitude)) |>
  glimpse()

# join shapefile and metadata
survey_lines_2 <- survey_shapefile_2 |> 
  left_join(survey_lines_metadata_2, by = "Id") |> 
  mutate(stream = paste(watershed, "River")) |>
  assign_sub_basin(sub_basin, is_point = FALSE) |> 
  select(-watershed) |> 
  glimpse()

print(st_crs(survey_shapefile_2))
print(st_geometry_type(survey_shapefile_2))

# survey points
survey_points <- read_csv(here::here('data-raw','redd_carcass.csv')) |>
  clean_names() |>
  filter(id >= 14 & id <= 17 | id >= 21 & id <= 27,
         !is.na(upstream_lat)) |> 
  select(-c(upstream_google_earth, upstream_rkm, downstream_google_earth, downstream_lat, downstream_long)) |>
  mutate(Id = id) |> 
  select(-id) |> 
  rename(latitude = upstream_lat,
         longitude = upstream_long) |>
  mutate(temporal_coverage = case_when(
    temporal_coverage == 2002 ~ "2002 fish kill event",
    TRUE ~ "2008"),
    agency = "CDFW",
    stream = paste(watershed, "River")) |>
  assign_sub_basin(sub_basin) |> 
  select(-watershed) |> 
  glimpse()

all_surveys <- bind_rows(survey_lines_1, survey_lines_2, survey_points) |>
  clean_names() |> 
  select(-c(id, label)) |> 
  select(stream, sub_basin, data_type, species, temporal_coverage,everything()) |>
  glimpse()

### USGS map layers ### ----
dams_tb_removed <- klamathWaterData::usgs_dam_removal_monitoring_layers$dams_tb_removed

dams <- klamathWaterData::usgs_dam_removal_monitoring_layers$dams

copco_res <- klamathWaterData::usgs_dam_removal_monitoring_layers$copco_res

estuary_bedsed <- klamathWaterData::usgs_dam_removal_monitoring_layers$estuary_bedsed

jc_boyle_reservoir_bedsed <- klamathWaterData::usgs_dam_removal_monitoring_layers$jc_boyle_reservoir_bedsed

ig_reservoir_bedsed <- klamathWaterData::usgs_dam_removal_monitoring_layers$ig_reservoir_bedsed

geomorphic_reaches <- klamathWaterData::usgs_dam_removal_monitoring_layers$geomorphic_reaches

sediment_bug <- klamathWaterData::usgs_dam_removal_monitoring_layers$sediment_bug

fingerprinting <- klamathWaterData::usgs_dam_removal_monitoring_layers$fingerprinting


### Species Distrubution Shapefiles ----
#chinook
chinook_extent <- read_sf("data-raw/species_distribution/Chinook_Abundance_Linear.shp") 
chinook_extent <- st_transform(chinook_extent, crs = 4326) 

chinook_extent <- st_intersection(chinook_extent, kl_basin_outline)

centroids <- st_centroid(chinook_extent)
chinook_extent$longitude <- st_coordinates(centroids)[, 1]
chinook_extent$latitude  <- st_coordinates(centroids)[, 2]
chinook_extent <- assign_sub_basin(chinook_extent, sub_basin, is_point = FALSE) 
chinook_extent <- chinook_extent |>
  filter(Location %in% streams$Label) 

#coho 
coho_extent <- read_sf("data-raw/species_distribution/Coho_Abundance_Linear.shp") 
coho_extent <- st_transform(coho_extent, crs = 4326)
coho_extent <- st_intersection(coho_extent, kl_basin_outline)
coho_extent <- assign_sub_basin(coho_extent, sub_basin, is_point = FALSE)
coho_extent <- coho_extent |>
  filter(Location %in% streams$Label) 
# steelhead 
steelhead_extent <- read_sf("data-raw/species_distribution/Steelhead_Abundance_Linear.shp") 
steelhead_extent <- st_transform(steelhead_extent, crs = 4326)
steelhead_extent <- st_intersection(steelhead_extent, kl_basin_outline)
steelhead_extent <- assign_sub_basin(steelhead_extent, sub_basin, is_point = FALSE)
steelhead_extent <- steelhead_extent |>
  filter(Location %in% streams$Label) 

habitat_extent <- bind_rows(coho_extent, steelhead_extent, chinook_extent) |>
  clean_names() |>
  select(-c(miles2, shape_len, fid, area, perimeter, kbbnd, kbbnd_id, shape_are, shape_len_1, global_id,trend_id, link)) |>
  mutate(stream = extract_waterbody(location),
         data_type = "fish habitat extent") |> 
  rename(species = c_name,
         species_full_name = s_name) |> 
  select(stream, sub_basin, data_type, location, species, species_full_name, run, everything()) |> 
  st_drop_geometry() |>
  glimpse()


###################
### ICON DEFINITIONS ----
###################
# 
rst_markers <- iconList(
  "single" = makeIcon("icon-diamond.png", "icon-diamond.png", 18, 18, 9, 9),
  "stack" = makeIcon("icon-diamond-stack.png", "icon-diamond-stack.png", 18, 18, 9, 9),
  "video" = makeIcon("icon-video.png", "icon-video.png", 18, 18, 9, 9),
  "T" = makeIcon("icon-t.png", "icon-t.png", 14, 14, 7, 7),
  "T-hollow" = makeIcon("icon-t-hollow.png", "icon-t-hollow.png", 14, 14, 7, 7),
  "H" = makeIcon("icon-spiral.png", "icon-spiral.png", 18, 18, 9, 9),
  "X" = makeIcon("icon-x.png", "icon-x.png", 14, 14, 7, 7),
  "circle-T" = makeIcon("icon-circle-t.png", "icon-circle-t.png", 18, 18, 9, 9),
  "circle-DO" = makeIcon("icon-circle-do.png", "icon-circle-do.png", 18, 18, 9, 9),
  "circle-F" = makeIcon("icon-circle-f.png", "icon-circle-f.png", 18, 18, 9, 9),
  "circle-TF" = makeIcon("icon-circle-tf.png", "icon-circle-tf.png", 18, 18, 9, 9),
  "square" = makeIcon("legend-bypass.png", "legend-bypass.png", 18, 18, 9, 9),
  "ph-icon" = makeIcon("ph-icon.png", "ph-icon.png", 18, 18, 9, 9)
)
reach_markers <- iconList(
  "001" = makeIcon("icon-circle-001.png", "icon-circle-001.png", 18, 18, 9, 9),
  "010" = makeIcon("icon-circle-010.png", "icon-circle-010.png", 18, 18, 9, 9),
  "100" = makeIcon("icon-circle-100.png", "icon-circle-100.png", 18, 18, 9, 9),
  "011" = makeIcon("icon-circle-011.png", "icon-circle-011.png", 18, 18, 9, 9),
  "101" = makeIcon("icon-circle-101.png", "icon-circle-101.png", 18, 18, 9, 9),
  "110" = makeIcon("icon-circle-110.png", "icon-circle-110.png", 18, 18, 9, 9),
  "111" = makeIcon("icon-circle-111.png", "icon-circle-111.png", 18, 18, 9, 9)
)


# do_icon <- makeAwesomeIcon(
#   icon = "tint",
#   library = "fa",  
#   markerColor = "blue", 
#   iconColor = "white",
#   squareMarker = TRUE)

# ph_icon <- makeAwesomeIcon(
#   icon = "tint",
#   library = "fa", 
#   markerColor = "green",  
#   iconColor = "white")

