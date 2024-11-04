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
    leaflet() %>%
      addTiles() %>%
      setView(lng = -122, lat = 41, zoom = 8) # Adjust to your desired coordinates and zoom level
  })
  
  # Observe the checkbox input to control the visibility of the markers
  observe({
    leafletProxy("mainMap") %>%
      clearMarkers()
    
    if (input$show_temp_loggers) {
      # Add flow gage markers
      leafletProxy("mainMap") %>%
        addCircleMarkers(
          data = flow,
          lng = ~longitude, lat = ~latitude, # Ensure column names match your data
          color = "blue",
          radius = 5,
          popup = ~paste("Flow Gage:", gage_number) # Customize based on `flow` data fields
        )
      
      # Add temperature logger markers
      leafletProxy("mainMap") %>%
        addCircleMarkers(
          data = temperature,
          lng = ~longitude, lat = ~latitude, # Ensure column names match your data
          color = "red",
          radius = 5,
          popup = ~paste("Temperature Gage:", gage_number) # Customize based on `temperature` data fields
        )
    }
  })
  
})
