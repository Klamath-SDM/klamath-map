library(tidyverse)
library(shiny)
library(leaflet)
library(sf)
library(janitor)
#library(shinyauthr)

#source("funcs.R")
#source("modules/monitoring_module.R")
#source("modules/reference_module.R")

#readRenviron(".Renviron")


###############
# DATA IMPORTS 
###############
#klamath basin outline 
river_shapefile <- st_read("data-raw/R8_FAC_Klamath_Basin_WFL1/R8_FAC_Klamath_Basin_WFL1.shp")

# add in temperature and flow data 
temperature <- read_csv(here::here('data-raw', 'temp_data.csv')) 
  # sf::st_as_sf(coords = c("longitude","latitude")) 
flow <- read_csv(here::here('data-raw', 'flow_table.csv')) 
  # sf::st_as_sf(coords = c("longitude","latitude"))


# Import RST data
# rst_trap_locations <- readRDS("data/rst_trap_locations.Rds")
rst_sites <- read_csv(here::here('data-raw', 'rst_sites.csv')) |> 
  clean_names() |> 
  select(rst_name, operator, latitude, longitude, link) |> 
  glimpse()

# Klamath River Basin Shp
kl_basin_outline <- st_read("data-raw/R8_FAC_Klamath_Basin_WFL1/R8_FAC_Klamath_Basin_WFL1.shp")

kl_basin_outline <- st_transform(kl_basin_outline, crs = 4326)

# sub-basin boundaries
sub_basin <- st_read("data-raw/sub-basin-boundaries/Klamath_HUC8_Subbasin.shp")

sub_basin <- st_transform(sub_basin, crs = 4326)

# basin stream lines
streams <- st_read("data-raw/klamath_basin_river_lines/Merged_Rivers.shp")
streams <- st_transform(streams, crs = 4326)

# Import habitat extent data
habitat_data <- read_csv(here::here('data-raw','habitat_data.csv')) |> 
  clean_names() |>
  mutate(longitude = as.numeric(longtidue)) |>
  select(-longtidue) |>
  glimpse()

# Hatcheries

hatcheries <- read_csv(here::here('data-raw','fish_hatchery_locations.csv')) |> 
  clean_names() |> 
  select(-c(google_earth_location)) 

# Redd and Carcass Surveys----
## Survey Lines
# shapefile 1 ---
survey_shapefile_1 <- st_read("data-raw/redd_suervey_coho_USGWS/redd_survey_coho_USFWS.shp") 
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
  glimpse()
# join shapefile and metadata
survey_lines_1 <- survey_shapefile_1 |> 
  left_join(survey_lines_metadata_1, by = "Id") 

print(st_crs(survey_shapefile_1))
print(st_geometry_type(survey_shapefile_1))


# shapefile 2 ---
survey_shapefile_2 <- st_read("data-raw/redd_suervey_coho_USGWS/redd_carcass_fall_chinook.shp") |> select(-Shape_Leng)
survey_shapefile_2 <- st_transform(survey_shapefile_2, crs = 4326)
#metadata of those on shapefiles
survey_lines_metadata_2 <- read_csv(here::here('data-raw','redd_carcass.csv')) |>
  clean_names() |>
  filter(id >= 18 & id <= 20) |> 
  select(-c(upstream_google_earth, upstream_rkm, downstream_google_earth, 
            downstream_lat, downstream_long, upstream_lat, upstream_long)) |>
  mutate(Id = id) |> 
  select(-id) |> 
  # select(-c(upstream_lat, upstream_long, downstream_long, downstream_lat, data_type)) |>
  # filter(!is.na(latitude)) |>
  glimpse()

# join shapefile and metadata
# join shapefile and metadata
survey_lines_2 <- survey_shapefile_2 |> 
  left_join(survey_lines_metadata_2, by = "Id") 

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
  glimpse()

# survey_spatial <- survey_type |>
#   # rowwise() |>
#   filter(!is.na(downstream_long)) |>
#   mutate(geometry = st_sfc(st_polygon(list(matrix(c(downstream_long, downstream_lat,
#                                                     downstream_long, upstream_lat,
#                                                     upstream_long, upstream_lat,
#                                                     upstream_long, downstream_lat,
#                                                     downstream_long, downstream_lat),
#                                                   ncol = 2, byrow = TRUE))),
#                            crs = 4326)) |>
#   st_as_sf()
# 
# 
# surveyed_river <- st_intersection(kl_corridor, survey_spatial)
# plot(surveyed_river["geometry"])
# 
# surveyed_river_extent <- surveyed_river |> 
#   group_by(watershed, agency, temporal_coverage, data_type, species, location_description) |> 
#   summarise(
#     geometry = st_union(geometry),
#     .groups = 'drop'  
#   )

# USGS map layers ----

dams_tb_removed <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/Dams_to_be_removed.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
dams <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/Dams.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
kl_corridor <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/Klamath_River_Corridor.shp")
copco_res <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_Copco_Reservoir_bed_sediment_cores.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
estuary_bedsed <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_Estuary_bed_sediment_samples.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
jc_boyle_reservoir_bedsed <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_JCBoyle_Reservoir_bed_sediment_cores.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
ig_reservoir_bedsed <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_IronGate_Reservoir_bed_sediment_cores.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
geomorphic_reaches <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_Mainstem_Geomorphic_Reaches.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
sediment_bug <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_Sediment_Bug_Samples.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
stream_gages <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_stream_gages.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])
fingerprinting <- read_sf("data-raw/usgs_dam_removal_map/klamath_map_shapefiles/USGS_Tributary_Fingerprinting_Samples.shp") |> 
  mutate(longitude = st_coordinates(geometry)[, 1],
         latitude = st_coordinates(geometry)[, 2])



# bbox <- rst_trap_locations |> st_bbox()
# river_bounds <- readRDS("data/river_bounds.rds")
# 
# 
# ##################
# # ICON DEFINITIONS 
# ##################
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
  "circle-F" = makeIcon("icon-circle-f.png", "icon-circle-f.png", 18, 18, 9, 9),
  "circle-TF" = makeIcon("icon-circle-tf.png", "icon-circle-tf.png", 18, 18, 9, 9),
  "square" = makeIcon("legend-bypass.png", "legend-bypass.png", 18, 18, 9, 9)
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
