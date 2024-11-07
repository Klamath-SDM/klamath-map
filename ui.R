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
        )
        ,
        
        hr(),
        tags$div(
          class = "legend-item",
          checkboxInput(
            "show_temp_loggers",
            "Gages and Temperature Loggers",
            value = TRUE
          ),
          HTML(
            "<ul class='legend-list'>
                <li><img src='icon-circle-f.png'  /> USGS flow gage</li>
                <li><img src='icon-circle-t.png'  /> USGS temperature gage</li>
              </ul>"
          )
        ),
        hr(),
        tags$div(
          class = "legend-item",
          checkboxInput(
            "show_rst",
            "Rotary Screw Traps",
            value = TRUE
          ),
          HTML( #potentially delete multiple traps legend/change legend
            "<ul class='legend-list'>
              <li><img src='icon-diamond.png' /> Single Trap</li>
              <li><img src='icon-diamond-stack.png' /> Multiple Traps</li>
            </ul>"
          ),
          p(class="legend-description", "Private rotary screw trap sites are illustrated as general vicinities (half mile radius).")
        )
      ),
      mainPanel(
        leafletOutput("mainMap")
      )
    )
  )
)
