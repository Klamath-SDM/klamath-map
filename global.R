library(tidyverse)
library(shiny)
library(leaflet)
library(sf)
library(shinyauthr)

source("funcs.R")
source("modules/monitoring_module.R")
source("modules/reference_module.R")

###############
# DATA IMPORTS 
###############

# TODO Add in data for the Klamath Basin

# Import RST data
# rst_trap_locations <- readRDS("data/rst_trap_locations.Rds")
# rst_sites <- readRDS("data/rst_sites.Rds")
# rst_sites_circ <- readRDS("data/rst_sites_circ.Rds")
# 
# # Import temp loggers data
# temp_loggers <- readRDS("data/temp_loggers.Rds")
# gages_cdec_usgs <- readRDS("data/gages_cdec_usgs.Rds")
# 
# # Import survey reaches data
# survey_reaches <- readRDS("data/survey_reaches.Rds")
# survey_reach_detail <- readRDS("data/survey_reach_detail.Rds")
# survey_reach_breaks <- readRDS("data/survey_reach_breaks.Rds")
# 
# # Import video monitor data
# video_mon <- readRDS("data/video_mon.Rds")
# video_mon_circle <- readRDS("data/video_mon_circle.Rds")
# 
# # Import habitat extent data
# salmonid_habitat_extents <- readRDS("data/salmonid_habitat_extents.Rds")
# spawning_habitat <- salmonid_habitat_extents |> 
#   filter((species_ha == "Spring Run Chinook - spawning"))
# rearing_habitat <- salmonid_habitat_extents |> 
#   filter((species_ha == "Spring Run Chinook - rearing"))
# other_habitat <- salmonid_habitat_extents |> 
#   filter((is.na(species_ha)))
# 
# bypasses <- readRDS("data/bypasses.Rds")
# hatcheries <- readRDS("data/hatcheries.Rds")
# 
# bbox <- rst_trap_locations |> st_bbox()
# river_bounds <- readRDS("data/river_bounds.rds")
# 
# 
# ##################
# # ICON DEFINITIONS 
# ##################
# 
# rst_markers <- iconList(
#   "single" = makeIcon("icon-diamond.png", "icon-diamond.png", 18, 18, 9, 9),
#   "stack" = makeIcon("icon-diamond-stack.png", "icon-diamond-stack.png", 18, 18, 9, 9),
#   "video" = makeIcon("icon-video.png", "icon-video.png", 18, 18, 9, 9),
#   "T" = makeIcon("icon-t.png", "icon-t.png", 14, 14, 7, 7),
#   "T-hollow" = makeIcon("icon-t-hollow.png", "icon-t-hollow.png", 14, 14, 7, 7),
#   "H" = makeIcon("icon-spiral.png", "icon-spiral.png", 18, 18, 9, 9),
#   "X" = makeIcon("icon-x.png", "icon-x.png", 14, 14, 7, 7),
#   "circle-T" = makeIcon("icon-circle-t.png", "icon-circle-t.png", 18, 18, 9, 9),
#   "circle-F" = makeIcon("icon-circle-f.png", "icon-circle-f.png", 18, 18, 9, 9),
#   "circle-TF" = makeIcon("icon-circle-tf.png", "icon-circle-tf.png", 18, 18, 9, 9)
# )
# reach_markers <- iconList(
#   "001" = makeIcon("icon-circle-001.png", "icon-circle-001.png", 18, 18, 9, 9),
#   "010" = makeIcon("icon-circle-010.png", "icon-circle-010.png", 18, 18, 9, 9),
#   "100" = makeIcon("icon-circle-100.png", "icon-circle-100.png", 18, 18, 9, 9),
#   "011" = makeIcon("icon-circle-011.png", "icon-circle-011.png", 18, 18, 9, 9),
#   "101" = makeIcon("icon-circle-101.png", "icon-circle-101.png", 18, 18, 9, 9),
#   "110" = makeIcon("icon-circle-110.png", "icon-circle-110.png", 18, 18, 9, 9),
#   "111" = makeIcon("icon-circle-111.png", "icon-circle-111.png", 18, 18, 9, 9)
# )
