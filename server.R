shinyServer(function(input, output, session) {
  
  # source("modules/monitoring_module.R")
  # source("modules/reference_module.R")
  
  # monitoring_tab_server("monitoring")
  
  insertUI(
    selector = ".navbar .container-fluid .navbar-collapse",
    ui = tags$ul(class = "nav navbar-nav navbar-right",
                 tags$li(
                   div(style = "padding: 10px; padding-top: 8px; padding-bottom: 0;",
                       shinyauthr::logoutUI("logout"))
                 ))
  )
  
  output$mainMap <- renderLeaflet({
    leaflet() |> 
      addTiles() |> 
      setView(lng = -122, lat = 41, zoom = 8) 
  })
  
  observe({
    leafletProxy("mainMap") |> 
      clearMarkers()
    
    if (input$show_temp_loggers) {
      # Add flow gages
      leafletProxy("mainMap") |> 
        addMarkers(
          data = flow,
          lng = ~longitude, lat = ~latitude, 
          icon = ~ rst_markers["circle-F"],
          # color = "blue",
          # radius = 5,
          popup = ~paste("Flow Gage:", gage_number) #TODO add other pop-ups, potentially adding a graph when clicked
        )
      
      # Add temperature gages
      leafletProxy("mainMap") |> 
        addMarkers(
          data = temperature,
          lng = ~longitude, lat = ~latitude, 
          icon = ~ rst_markers["circle-T"],
          # color = "blue",
          # radius = 5,
          popup = ~paste("Temperature Gage:", gage_number)
        )
    }
  })
  
  observe({
    # Check if the "show_rst" checkbox is checked
    if (input$show_rst) {
      leafletProxy("mainMap") |>
        addMarkers(
          data = rst_sites,
          lng = ~longitude, lat = ~latitude,
          icon = ~ rst_markers["single"],
          popup = ~paste("RST Name:", rst_name),
          # layerId = ~uid, # Uncomment if needed
          # label = ~lapply(if_else(!is.na(image_embed), paste0(popup, "<p><strong>Click for more details &rarr;</strong></p>"), popup), htmltools::HTML),
          group = "Rotary Screw Traps"
        )
    } else {
      # Remove rotary screw trap markers if the checkbox is unchecked
      leafletProxy("mainMap") |>
        clearGroup("Rotary Screw Traps")
    }
  })
})
