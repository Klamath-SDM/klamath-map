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
#klamath basin outline - TODO add basin polygon
river_shapefile <- st_read("data-raw/R8_FAC_Klamath_Basin_WFL1/R8_FAC_Klamath_Basin_WFL1.shp")

# add in temperature and flow data 
temperature <- read_csv(here::here('data-raw', 'temp_data.csv')) 
  # sf::st_as_sf(coords = c("longitude","latitude")) 
flow <- read_csv(here::here('data-raw', 'flow_table.csv')) 
  # sf::st_as_sf(coords = c("longitude","latitude"))

# TODO Add in data for the Klamath Basin

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

# Redd and Carcass

survey_type <- read_csv(here::here('data-raw','redd_carcass.csv')) |> 
  clean_names() |> 
  select(-c(upstream_google_earth, upstream_rkm, upstream_google_earth, downstream_google_earth)) |> 
  mutate(latitude = downstream_lat,
         longitude = downstream_long,
         adult_survey_type = data_type) |> 
  select(-c(upstream_lat, upstream_long, downstream_long, downstream_lat, data_type)) |> 
  filter(!is.na(latitude)) |> 
  glimpse()

# USGS map layers
# 
# folder_path <- "data-raw/usgs_dam_removal_map/klamath_map_shapefiles/"
# shapefiles <- list.files(folder_path, pattern = "\\.shp$", full.names = TRUE)
# shapefile_list <- map(shapefiles, ~ st_read(.x) |> clean_names())
# names(shapefile_list) <- gsub(".shp$", "", basename(shapefiles))
# 
# # Exclude specific layers
# excluded_layers <- c("Klamath_Basin", "Watersheds_HUC8")
# shapefile_list <- shapefile_list[!names(shapefile_list) %in% excluded_layers]
# 
# # Create color palette for point layers
# point_layer_names <- names(shapefile_list)[sapply(shapefile_list, function(x) "POINT" %in% st_geometry_type(x))]
# color_palette <- colorFactor(palette = "Set1", domain = point_layer_names)
# 
# # Function to add shapefile layers to a map
# add_shapefile_layer <- function(map, shapefile, shapefile_name, color_palette) {
#   geom_type <- unique(st_geometry_type(shapefile))
#   label_content <- if ("name" %in% names(shapefile)) {
#     shapefile$name  # Use 'name' column if available
#   } else {
#     str_to_title(shapefile_name)
#   }
#   
#   if ("POLYGON" %in% geom_type | "MULTIPOLYGON" %in% geom_type) {
#     map <- map |> 
#       addPolygons(
#         data = shapefile,
#         color = "blue",
#         fill = TRUE,
#         fillOpacity = 0.5,
#         group = shapefile_name
#         # label = ~label_content
#       )
#   } else if ("POINT" %in% geom_type) {
#     layer_color <- color_palette(shapefile_name)
#     map <- map |> 
#       addCircleMarkers(
#         data = shapefile,
#         color = layer_color,
#         radius = 5,
#         group = shapefile_name
#         # label = ~label_content
#       )
#   } else if ("LINESTRING" %in% geom_type) {
#     map <- map |> 
#       addPolylines(
#         data = shapefile,
#         color = "green",
#         group = shapefile_name
#         # label = ~label_content
#       )
#   } else {
#     warning(paste("Unsupported geometry type in layer:", shapefile_name))
#   }
#   map
# }


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
  "circle-TF" = makeIcon("icon-circle-tf.png", "icon-circle-tf.png", 18, 18, 9, 9)
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
