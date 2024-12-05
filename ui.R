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
            "Zoom to Basin",
            c(
              "(Default View)",
              "Williamson",
              "Sprague",
              "Upper Klamath Lake",
              "Butte",
              "Shasta",
              "Scott",
              "Lower Klamath",
              "Salmon",
              "Trinity",
              "South Fork Trinity",
              "Lost"
            )
          ),
          
          hr(),
          
          # Basin Outline
          checkboxInput("show_basin_outline", "Klamath River Basin Outline", value = TRUE),
          checkboxInput("show_sub_basin_outline", "Klamath Sub Basin Boundaries", value = TRUE),
          checkboxInput("show_streams", "Klamath Basin Streams", value = TRUE),
          
          # redd_survey TEST ---
          checkboxInput("show_redd_test", "Redd Survey Reaches", value = TRUE),
          
          
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
            p(class = "legend-description", "For more information on Flow data exploration click",
              tags$a(href = 'https://github.com/Klamath-SDM/klamath-map/blob/add-gages/data-raw/flow_data_exploration/explore_flow_gages.md', 
                     "here", target = "_blank"), 
              ". For more information on Temperature data exploration click",
              tags$a(href = 'https://github.com/Klamath-SDM/klamath-map/blob/add-gages/data-raw/temperature_data_exploration/explore_temp_gages.md', 
                     "here", target = "_blank"))
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
            p(class = "legend-description", "For more detailed data exploration information click",
              tags$a(href = 'https://github.com/Klamath-SDM/Klamath-map/blob/add-gages/data-raw/habitat_summary.md', 
                     "here", target = "_blank"))
          ),
          
          hr(),
          
          # Survey Type
          # tags$div(
          #   class = "legend-item",
          #   checkboxInput("show_upstream_buffer",
          #                 "Survey Extent - Redd/Carcass (Upstream)",
          #                 value = TRUE),
          #   # htmltools::HTML(
          #   #   "<img src='legend-habitat-2.png' /> Survey Extent Redd and Carcass Surveys"
          #   # ),
          #   p(class = "legend-description", "[Placeholder for legend].")
          # ),
          # hr(),
          # 
          # tags$div(
          #   class = "legend-item",
          #   checkboxInput("show_downstream_buffer",
          #                 "Survey Extent - Redd/Carcass (Downstream)",
          #                 value = TRUE),
          #   # htmltools::HTML(
          #   #   "<img src='legend-habitat-2.png' /> Survey Extent Redd and Carcass Surveys"
          #   # ),
          #   p(class = "legend-description", "[Placeholder for legend].")
          # ),
          # hr(),
          
        
          # USGS Dam Removal Map Layers
          tags$div(
            class = "legend-item",
            checkboxInput("show_usgs_dam_layers", "USGS Dam Removal Map Layers", value = TRUE),
            conditionalPanel(
              condition = "input.show_usgs_dam_layers == true",
              checkboxInput("show_dams_tb_removed", HTML("<span style='color:red;'>&#9673;</span> Dams to be Removed"), value = TRUE),
              checkboxInput("show_dams", HTML("<span style='color:blue;'>&#9673;</span> Existing Dams"), value = TRUE),
              checkboxInput("show_kl_corridor", HTML("<span style='color:green;'>&#9673;</span> Klamath River Corridor"), value = TRUE),
              checkboxInput("show_copco_res", HTML("<span style='color:orange;'>&#9673;</span> Copco Reservoir Bed Sediment Cores"), value = TRUE),
              checkboxInput("show_estuary_bedsed", HTML("<span style='color:purple;'>&#9673;</span> Estuary Bed Sediment Samples"), value = TRUE),
              checkboxInput("show_jc_boyle_reservoir_bedsed", HTML("<span style='color:cyan;'>&#9673;</span> JCBoyle Reservoir Bed Sediments"), value = TRUE),
              checkboxInput("show_ig_reservoir_bedsed", HTML("<span style='color:lavender;'>&#9673;</span> Iron Gate Reservoir Bed Sediment Cores"), value = TRUE),
              checkboxInput("show_geomorphic_reaches", HTML("<span style='color:brown;'>&#9673;</span> Geomorphic Reaches"), value = TRUE),
              checkboxInput("show_sediment_bug", HTML("<span style='color:yellow;'>&#9673;</span> Sediment Bug Samples"), value = TRUE),
              checkboxInput("show_stream_gages", HTML("<span style='color:black;'>&#9673;</span> Stream Gages"), value = TRUE),
              checkboxInput("show_fingerprinting", HTML("<span style='color:lightgreen;'>&#9673;</span> Tributary Fingerprinting Samples"), value = TRUE)
            )
          ),
          p(class = "legend-description", "These layers were sourced from",
            tags$a(href = 'https://ca.water.usgs.gov/apps/klamath-dam-removal-monitoring.html', 
                   "USGS Dam Removal Monitorning Map", target = "_blank"))
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
                     href = "klamath_suckers_infographic.pdf",
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
               ),
                          tags$li(
                            tags$a(
                              href = "flow_model_resources.pdf",
                              target = "_blank",
                              "Flow Model Resources"
                            )
                          )
      )
    )
  )
)
)
# next steps - add another section to compile literature and their locations 
