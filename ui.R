library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Klamath SDM Map"),
  
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
        
        # Temperature and Flow Gages Checkbox with Legend
        tags$div(
          class = "legend-item",
          checkboxInput(
            "show_temp_loggers",
            "Gages and Temperature Loggers",
            value = TRUE
          ),
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
          checkboxInput(
            "show_rst",
            "Rotary Screw Traps",
            value = TRUE
          ),
          HTML(
            "<ul class='legend-list'>
              <li><img src='icon-diamond.png' /> Single Trap</li>
              <li><img src='icon-diamond-stack.png' /> Multiple Traps</li>
            </ul>"
          ),
          p(class = "legend-description", "Private rotary screw trap sites are illustrated as general vicinities (half mile radius).")
        ),
        
        hr(),
        
        # Fish Hatcheries Checkbox
        tags$div(
          class = "legend-item",
          checkboxInput(
            "show_hatcheries",
            "Hatcheries",
            value = TRUE
          ),
            HTML(
              "<img src='icon-spiral.png' style='width: 20px; height: 20px;' /> Fish Hatcheries"),
          ),
          # Uncomment below if additional description is needed
          # p(class = "legend-description", "Fish hatchery description here")
      ),
      
      # Main Panel for Map Display
      mainPanel(
        leafletOutput("mainMap")
      )
    )
  )
)
