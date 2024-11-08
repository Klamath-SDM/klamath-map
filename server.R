shinyServer(function(input, output, session) {
  
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
  
  # Define coordinates for each river
  river_coords <- list(
    "Klamath River" = c(-122.85, 41.95),
    "Trinity River" = c(-123.1, 41.0),
    "Upper Klamath Lake" = c(-121.79, 42.5),
    "Lost River" = c(-121.56, 42.0),
    "Williamson River" = c(-121.88, 42.7),
    "Wood River" = c(-121.86, 42.8),
    "Link River" = c(-121.8, 42.22),
    "Scott River" = c(-123.0, 41.55),
    "Shasta River" = c(-122.43, 41.8),
    "Indian Creek" = c(-122.84, 41.55),
    "Sprague River" = c(-121.5, 42.4)
  )
  
  # Observer for zooming to selected river
  observeEvent(input$zoom_select_river, {
    selected_river <- input$zoom_select_river
    if (selected_river != "(Default View)" && selected_river %in% names(river_coords)) {
      coords <- river_coords[[selected_river]]
      leafletProxy("mainMap") %>% setView(lng = coords[1], lat = coords[2], zoom = 10)
    } else {
      leafletProxy("mainMap") %>% setView(lng = -122.85, lat = 41.95, zoom = 7)
    }
  })
  
  # Observer to handle temperature and flow gages display
  observe({
    proxy <- leafletProxy("mainMap") |> clearMarkers()
    
    if (input$show_temp_loggers) {
      proxy |> addMarkers(
        data = flow,
        lng = ~longitude, lat = ~latitude, 
        icon = ~ rst_markers["circle-F"],
        popup = ~paste("Flow Gage Number:", gage_number, "<br>Latest Date:", latest_data, "<br>Earliest Date:", earliest_data),
        label = ~htmltools::HTML("<em>USGS Flow Gage</em>")
      ) |>
        addMarkers(
          data = temperature,
          lng = ~longitude, lat = ~latitude, 
          icon = ~ rst_markers["circle-T"],
          popup = ~paste("Temperature Gage Number:", gage_number, "<br>Latest Date:", latest_data, "<br>Earliest Date:", earliest_data),
          label = ~htmltools::HTML("<em>USGS Temperature Gage</em>")
        )
    }
  })
  
  # Observer to manage RST Traps with hover pop-up and more info button
  observe({
    if (input$show_rst) {
      leafletProxy("mainMap") |>
        addMarkers(
          data = rst_sites,
          lng = ~longitude, lat = ~latitude,
          icon = ~ rst_markers["single"],
          popup = ~paste("<em>RST Trap</em><br>", "Trap Name:", rst_name, 
                         "<br><button onclick='Shiny.setInputValue(\"more_info\", \"", rst_name, "\")'>More Info</button>"),
          label = ~htmltools::HTML("<em>RST Trap</em>"),
          group = "Rotary Screw Traps"
        )
    } else {
      leafletProxy("mainMap") |> clearGroup("Rotary Screw Traps")
    }
  })
  
  # Observer to manage Hatchery markers
  observe({
    if (input$show_hatcheries) {
      leafletProxy("mainMap") |>
        addMarkers(
          data = hatcheries,
          lng = ~longitude, lat = ~latitude,
          icon = ~ rst_markers["H"],
          popup = ~paste("<em>Hatchery</em><br>", "Hatchery Name:", site_name, 
                         "<button onclick=\"window.open('", resource, "', '_blank')\">More Info</button>"),
          label = ~htmltools::HTML("<em>Hatchery</em>"),
          group = "Hatcheries"
          # label = ~ lapply(popup, htmltools::HTML),
          # popup = ~ popup,
          # options = leaflet::pathOptions(pane = "Points-Hatcheries")
        )
    } else {
      leafletProxy("mainMap") |> clearGroup("Hatcheries")
    }
  })
  
  # Additional observers and layers can be added here following a similar structure
  
}) # Properly closing shinyServer


