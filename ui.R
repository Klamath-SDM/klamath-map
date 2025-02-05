library(shiny)
library(leaflet)
library(DT)

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
          h5("There is a wealth of data about water and ecological resources in the Klamath Basin collected over multiple decades by many entities. The high volume and dispersed nature of these data make it challenging to quickly determine data availability. This map was developed to support the Klamath Basin Science Collaborative by summarizing the data being collected in the Basin."),
          br(),
          
          # Select Input for Zooming to Rivers
          selectInput(
            "zoom_select_river", 
            "Zoom to Basin",
            c(
              "(Default View)", sort(c(
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
              ))),
          
          hr(),
          
          # Basin Outline
           # checkboxInput("show_basin_outline", "Klamath River Basin Outline", value = TRUE),
          checkboxInput("show_sub_basin_outline", "Klamath Sub Basin Boundaries", value = TRUE),
          checkboxInput("show_streams", "Klamath Basin Streams", value = TRUE),
          
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
            )
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
            p(class = "legend-description", "Some models were aleady developed, some are being developed now. For more detailed data exploration information click",
              tags$a(href = 'https://github.com/Klamath-SDM/Klamath-map/blob/add-gages/data-raw/habitat_summary.md', 
                     "here", target = "_blank"))
          ),
          
          hr(),
          
          # Redd/Carcass Survey Layers
          tags$div(
            class = "legend-item",
            checkboxInput("show_survey_layers", "Redd/Carcass Survey Layers", value = TRUE),
            htmltools::HTML("<img src='legend-habitat-1.png' style='width: 20px; height: 20px;' /> Redd/Carcass Survey Reaches"),
            htmltools::HTML("<div style='display: block; margin-top: 5px;'><img src='legend-bypass.png' style='width: 20px; height: 20px;' /> Redd/Carcass Survey Points</div>")
          ),
          # add description of points vs lines
          hr(),
          
          # USGS Dam Removal Map Layers
          tags$div(
            class = "legend-item",
            checkboxInput("show_usgs_dam_layers", "USGS Dam Removal Monitoring Map Layers", value = TRUE),
            conditionalPanel(
              condition = "input.show_usgs_dam_layers == true",
              checkboxInput("show_dams_tb_removed", HTML("<span style='color:red;'>&#9673;</span> Removed Dams"), value = TRUE),
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
                   "USGS Dam Removal Monitoring Map", target = "_blank"))
        ),
        
        mainPanel(
          leafletOutput("mainMap")
        )
      )
    ),
    
    # Additional Resources Tab
    # tabPanel(
    #   "Additional Resources",
    #   tags$div(class = "reference-content",
    #            HTML("<p><strong>Additional resources</strong></p>"),
    #            tags$ul(
    #              tags$li(
    #                tags$a(
    #                  href = "klamath_suckers_infographic.pdf",
    #                  target = "_blank",
    #                  "Suckers Infographic"
    #                )
    #              ),
    #              tags$li(
    #                tags$a(
    #                  href = "chinook-salmon-migration-timing.pdf",
    #                  target = "_blank",
    #                  "Chinook Migration Timing Conceptual Map"
    #                )
    #              ),
    #              tags$li(
    #                tags$a(
    #                  href = "https://klamathtribeswaterquality.com/reports/",
    #                  target = "_blank",
    #                  "The Klamath Tribes Water Quality Report Repository"
    #                )
    #              ),
    #              tags$li(
    #                tags$a(
    #                  href = "flow_model_resources.pdf",
    #                  target = "_blank",
    #                  "Flow Model Resources")
    #              )
    #            )
    #   )
    # ),
    # 
    # Data Explorer Tab
    tabPanel(
      "Data Explorer",
      sidebarLayout(
        sidebarPanel(
          h5("This tab displays summarized tabular data categorized by data type. Additional filtering options (e.g., watershed, agency, etc.) will be available. The 'Go to Map' button will direct users to the location on the map where the selected data row was collected.
             This section is still in progress and will undergo multiple iterations."),
          br(),
          selectInput("data_type", "Select Data Type:",
                      choices = c("Select Data Type", "Flow Data", "Temperature Data", "Habitat Data", "RST Data")),
          selectInput("watershed", "Select Watershed: (pending)",
                      choices = c("All")), 
                                  # "Williamson", "Sprague", "Upper Klamath Lake", "Butte", "Shasta", "Scott", "Lower Klamath", "Salmon", "Trinity", "South Fork Trinity", "Lost")),
          # hr()
        ),
        mainPanel(
          # div(style = "height: 800px; width: 100%; overflow-x: auto;",
              DTOutput("data_table")
        )
      )
    )
  )
)

# next steps - add action button to table so that when you click it directs you to that data on map
# add another dropdown to filter by watershed, maybe other criteria too
