library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Klamath SDM Map"),
  
  # Main Panel with Tabs
  tabsetPanel(
    tabPanel(
      "Monitoring Site Map",
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$script(src = "scripts/lightbox/js/lightbox.js"),
        tags$link(rel = "stylesheet", type = "text/css", href = "scripts/lightbox/css/lightbox.css")
      ),
      
      sidebarLayout(
        sidebarPanel(
          h5("This map was developed to support the Klamath SDM effort led by US Bureau of Reclamation."),
          br(),
          
          # Select Input for Zooming to Rivers
          selectInput(
            "zoom_select_river", 
            "Zoom to River",
            c(
              "(Default View)",
              "Klamath River",
              "Trinity River",
              "Upper Klamath Lake",
              "Lost River",
              "Williamson River",
              "Wood River",
              "Link River",
              "Scott River",
              "Shasta River",
              "Indian Creek",
              "Sprague River"
            )
          ),
          
          hr(),
          
          # Basin Outline
          checkboxInput("show_basin_outline", "Klamath River Basin Outline", value = TRUE),
          checkboxInput("show_sub_basin_outline", "Klamath Sub Basin Boundaries", value = TRUE),
          
          # Gages and Temperature Loggers
          tags$div(
            class = "legend-item",
            checkboxInput("show_temp_loggers", "Gages and Temperature Loggers", value = TRUE),
            HTML(
              "<ul class='legend-list'>
          <li><img src='icon-circle-f.png' /> USGS flow gage</li>
          <li><img src='icon-circle-t.png' /> USGS temperature gage</li>
        </ul>"
            ),
            p(class = "legend-description", "See",
              tags$a(href = 'https://github.com/Klamath-SDM/KlamathEDA/blob/add-flow-temp-shiny/data-raw/flow_data/explore_flow_gages.Rmd', 
                     "flow Rmd", target = "_blank"), 
              "and",
              tags$a(href = 'https://github.com/Klamath-SDM/KlamathEDA/blob/add-flow-temp-shiny/data-raw/temperature_data/explore_temp_gages.Rmd', 
                     "temp Rmd", target = "_blank"),
              "for more detailed data exploration.")
          ),
          
          hr(),
          
          # Rotary Screw Traps
          tags$div(
            class = "legend-item",
            checkboxInput("show_rst", "Rotary Screw Traps", value = TRUE),
            HTML(
              "<ul class='legend-list'>
          <li><img src='icon-diamond.png' /> Single Trap</li>
          <li><img src='icon-diamond-stack.png' /> Multiple Traps</li>
        </ul>"
            ),
            p(class = "legend-description", "Private rotary screw trap sites are illustrated as general vicinities (half mile radius).")
          ),
          
          hr(),
          
          # Fish Hatcheries
          tags$div(
            class = "legend-item",
            checkboxInput("show_hatcheries", "Hatcheries", value = TRUE),
            HTML("<img src='icon-spiral.png' style='width: 20px; height: 20px;' /> Fish Hatcheries")
          ),
          
          hr(),
          
          # Habitat Models
          tags$div(
            class = "legend-item",
            checkboxInput("show_habitat_data", "Habitat Models", value = TRUE),
            HTML(
              "<ul class='legend-list'>
          <li><img src='icon-x.png' /> Habitat Data</li>
        </ul>"
            ),
            p(class = "legend-description", "See",
              tags$a(href = 'https://github.com/Klamath-SDM/Klamath-map/blob/add-gages/data-raw/habitat_summary.Rmd', 
                     "Habitat Rmd", target = "_blank"), 
              "for more detailed data exploration.")
          ),
          
          hr(),
          
          # Survey Type
          # tags$div(
          #   class = "legend-item",
          #   checkboxInput("show_surveyed_river_extent", 
          #                 "Survey Extent - Redd/Carcass", 
          #                 value = TRUE),
          #   htmltools::HTML(
          #     "<img src='legend-habitat-2.png' /> Survey Extent Redd and Carcass Surveys"
          #   ),
          #   p(class = "legend-description", "[Placeholder for legend].")
          # ),
          # hr(),
          
          # USGS Dam Removal Map Layers
          tags$div(
            class = "legend-item",
            checkboxInput("show_usgs_dam_layers", "USGS Dam Removal Map Layers", value = TRUE),
            conditionalPanel(
              condition = "input.show_usgs_dam_layers == true",
            checkboxInput("show_dams_tb_removed", "Dams to be Removed", value = TRUE),
            checkboxInput("show_dams", "Existing Dams", value = TRUE),
            checkboxInput("show_kl_corridor", "Klamath River Corridor", value = TRUE),
            checkboxInput("show_copco_res", "Copco Reservoir Bed Sediment Cores", value = TRUE),
            checkboxInput("show_estuary_bedsed", "Estuary Bed Sediment Samples", value = TRUE),
            checkboxInput("show_ig_reservoir", "Iron Gate Reservoir", value = TRUE),
            checkboxInput("show_ig_reservoir_bedsed", "Iron Gate Reservoir Bed Sediment Cores", value = TRUE),
            checkboxInput("show_geomorphic_reaches", "Geomorphic Reaches", value = TRUE),
            checkboxInput("show_sediment_bug", "Sediment Bug Samples", value = TRUE),
            checkboxInput("show_stream_gages", "Stream Gages", value = TRUE),
            checkboxInput("show_fingerprinting", "Tributary Fingerprinting Samples", value = TRUE)
          )
          )
        ),
        
        mainPanel(
          leafletOutput("mainMap")
        )
      )
),
   
    # Additional Resources Tab
    tabPanel(
      "Additional Resources",
      tags$div(class = "reference-content",
               HTML("<p><strong>Additional resources</strong></p>"),
               tags$ul(
                 tags$li(
                   tags$a(
                     href = "suckers_infographic.pdf",
                     target = "_blank",
                     "Suckers Infographic"
                   )
                 ),
                 tags$li(
                   tags$a(
                     href = "chinook-salmon-migration-timing.pdf",
                     target = "_blank",
                     "Chinook Migration Timing Conceptual Map"
                   )
                 ),
                 tags$li(
                   tags$a(
                     href = "https://klamathtribeswaterquality.com/reports/",
                     target = "_blank",
                     "The Klamath Tribes Water Quality Report Repository"
                   )
               )
      )
    )
  )
)
)
# next steps - add another section to compile literature and their locations 
