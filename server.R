shinyServer(function(input, output, session) {
  
  # source("modules/monitoring_module.R")
  # source("modules/reference_module.R")
  # 
  # monitoring_tab_server("monitoring")
  
  output$mainMap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -121.5, lat = 41.7, zoom = 7)
  })

})
