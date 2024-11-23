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
  
  # Observer to manage Klamath Basin outline display
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_basin_outline) {
      proxy |>
        addPolygons(
          data = kl_basin_outline,
          color = "blue",  
          weight = 2,     
          opacity = 0.8,   
          fillOpacity = 0.2,  
          label = "Klamath River Basin",
          group = "Basin Outline"
        )
    } else {
      proxy |> clearGroup("Basin Outline")
    }
  })
  
  # Observer to manage sub-basin outline display
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_sub_basin_outline) {
      proxy |>
        addPolygons(
          data = sub_basin,
          color = "green",
          weight = 2,
          opacity = 0.8,
          fillOpacity = 0.2,
          label = ~paste(NAME, "Basin"),
          popup = ~paste("<em>Sub-Basin</em><br>", "Sub-Basin Name:", NAME),
          group = "Sub-Basin Outline"
        )
    } else {
      proxy |> clearGroup("Sub-Basin Outline")
    }
  })
  
  # Observer to manage temperature and flow gages display
  observe({
    proxy <- leafletProxy("mainMap") |> clearMarkers()
    if (input$show_temp_loggers) {
      proxy |> 
        addMarkers(
          data = flow,
          lng = ~longitude, lat = ~latitude, 
          icon = ~rst_markers["circle-F"],
          popup = ~paste("<em>Flow Gage</em><br>", "Gage Number:", gage_number, 
                         "<br>Latest Date:", latest_data, "<br>Earliest Date:", earliest_data,
                         "<button onclick=\"window.open('https://waterdata.usgs.gov/nwis/inventory?site_no=", 
                         gage_number, "', '_blank')\">Gage Site</button>"),
          label = ~htmltools::HTML("<em>USGS Flow Gage</em>")
        ) |> 
        addMarkers(
          data = temperature,
          lng = ~longitude, lat = ~latitude, 
          icon = ~rst_markers["circle-T"],
          popup = ~paste("<em>Temperature Gage</em><br>", "Gage Number:", gage_number, 
                         "<br>Latest Date:", latest_data, "<br>Earliest Date:", earliest_data,
                         "<button onclick=\"window.open('https://waterdata.usgs.gov/nwis/inventory?site_no=", 
                         gage_number, "', '_blank')\">Gage Site</button>"),
          label = ~htmltools::HTML("<em>USGS Temperature Gage</em>")
        )
    }
  })
  
  # Observer to manage RST Traps display
  observe({
    if (input$show_rst) {
      leafletProxy("mainMap") |>
        addMarkers(
          data = rst_sites,
          lng = ~longitude, lat = ~latitude,
          icon = ~rst_markers["single"],
          popup = ~paste("<em>RST Trap</em><br>", "Trap Name:", rst_name,
                         "<br><button onclick='Shiny.setInputValue(\"more_info\", \"", rst_name, "\")'>More Info</button>"),
          label = ~htmltools::HTML("<em>RST Trap</em>"),
          group = "Rotary Screw Traps"
        )
    } else {
      leafletProxy("mainMap") |> clearGroup("Rotary Screw Traps")
    }
  })
  
  # Observer for redd and carcass data
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_survey_type) {
      redd_data <- survey_type |> filter(adult_survey_type == "Redd")
      if (nrow(redd_data) > 0) {
        proxy |> addMarkers(
          data = redd_data,
          lng = ~longitude, lat = ~latitude,
          popup = ~paste("<em>Redd Adult Survey Reach</em><br>",
                         "Type of Survey: ", adult_survey_type, "<br>",
                         "Temporal Coverage: ", temporal_coverage, "<br>",
                         "<button onclick=\"window.open('", link, "', '_blank')\">More Information</button>"),
          label = ~htmltools::HTML("<em>Redd Survey</em>"),
          icon = ~reach_markers["010"],
          group = "Survey Data"
        )
      }
      #TODO change the hyperlink text under "link" so that it has the link to the source - Maybe just add the most recent report
      # check on temporal coverage 
      carcass_redd_data <- survey_type |> filter(adult_survey_type == "Carcass, Redd")
      if (nrow(carcass_redd_data) > 0) {
        proxy |> addMarkers(
          data = carcass_redd_data,
          lng = ~longitude, lat = ~latitude,
          popup = ~paste("<em>Redd and Carcass Adult Survey Reach</em><br>",
                         "Type of Survey: ", adult_survey_type, "<br>",
                         "Temporal Coverage: ", temporal_coverage, "<br>",
                         "<button onclick=\"window.open('", link, "', '_blank')\">More Information</button>"),
          label = ~htmltools::HTML("<em>Redd and Carcass Survey</em>"),
          icon = ~reach_markers["100"],
          group = "Survey Data"
        )
      }
    } else {
      proxy |> clearGroup("Survey Data")
    }
  })
})
