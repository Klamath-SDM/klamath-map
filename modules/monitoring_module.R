monitoring_tab_ui <- function(id) {
  ns <- NS(id)
  
  tabPanel(
    "Monitoring Site Map",
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$script(src = "scripts/lightbox/js/lightbox.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "scripts/lightbox/css/lightbox.css"),
    ),
    
    sidebarLayout(
      # fluidRow(
      sidebarPanel(
        tags$div(
          class = "legend-item",
          #checkboxInput("show_temp_loggers", htmltools::HTML("<img src='icon-t.png' /> Temperature Loggers"), value = TRUE, width = NULL),
          checkboxInput(
            ns("show_temp_loggers"),
            "Gages and Temperature Loggers",
            value = TRUE,
            width = NULL
          ),
          HTML(
            "<ul class='legend-list'>
                               <li><img src='icon-circle-f.png'  /> CDEC/USGS flow gage</li>
                               <li><img src='icon-circle-t.png'  /> CDEC/USGS temperature gage</li>
                               <li><img src='icon-circle-tf.png' /> CDEC/USGS flow and temperature gage</li>
                               <li><img src='icon-t.png' /> USFWS/CDFW temperature logger</li>
                          </ul>"
          ),
          #p(class="legend-description", "Temperature loggers operated by USFWS and CDFW.")
        )
      )
    )
    #mainPanel(fluidRow(leafletOutput(ns("mainMap"))))
  )
  
  
  
}