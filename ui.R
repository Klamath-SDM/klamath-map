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
          
          # Checkbox for Basin Outline
          checkboxInput("show_basin_outline", "Klamath River Basin Outline", value = TRUE),
          checkboxInput("show_sub_basin_outline", "Klamath Sub Basin Boundaries", value = TRUE),
          
          # Temperature and Flow Gages Checkbox with Legend
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
          
          # Rotary Screw Traps Checkbox with Legend
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
          
          # Fish Hatcheries Checkbox with Icon
          tags$div(
            class = "legend-item",
            checkboxInput("show_hatcheries", "Hatcheries", value = TRUE),
            HTML("<img src='icon-spiral.png' style='width: 20px; height: 20px;' /> Fish Hatcheries")
          ),
          
          hr(),
          
          # Habitat Data
          tags$div(
            class = "legend-item",
            checkboxInput("show_habitat_data", "Habitat Models", value = TRUE),
            HTML(
              "<ul class='legend-list'>
                  <li><img src='icon-x.png' /> Habitat Data</li>
                </ul>"
            ),
            p(class = "legend-description", "See",
              tags$a(href = 'https://github.com/Klamath-SDM/Klamath-map/blob/add-gages/data-raw/habitat_summary.Rmd', "Habitat Rmd", target = "_blank"), 
              "for more detailed data exploration.")
        ),
        hr(),
       
    # Survey Type
    tags$div(
      class = "legend-item",
      checkboxInput("show_survey_type", "Survey Type", value = TRUE),
      HTML(
        "<ul class='legend-list'>
                <li><img src='icon-circle-010.png' /> Redd</li>
                <li><img src='icon-circle-100.png' /> Carcass</li>
              </ul>"
      ),
      p(class = "legend-description", "[Placeholder for legend].")
    )
    ),
    # hr(),
    
    #USGS dam removal map
    # tags$div(
    #   class = "legend-item",
    #     checkboxGroupInput(
    #       inputId = "layer_selection",
    #       label = "Select Layers to Display:",
    #       choices = names(shapefile_list),
    #       selected = names(shapefile_list)
    #     )
    #   ),
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
