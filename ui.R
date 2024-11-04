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
        tags$div(
          class = "legend-item",
          checkboxInput(
            "show_temp_loggers",
            "Gages and Temperature Loggers",
            value = TRUE
          ),
          HTML(
            "<ul class='legend-list'>
                <li><img src='icon-circle-f.png'  /> CDEC/USGS flow gage</li>
                <li><img src='icon-circle-t.png'  /> CDEC/USGS temperature gage</li>
                <li><img src='icon-circle-tf.png' /> CDEC/USGS flow and temperature gage</li>
                <li><img src='icon-t.png' /> USFWS/CDFW temperature logger</li>
              </ul>"
          )
        )
      ),
      mainPanel(
        leafletOutput("mainMap")
      )
    )
  )
)
