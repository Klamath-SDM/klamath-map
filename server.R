shinyServer(function(input, output, session) {
  
  # Insert UI component
  insertUI(
    selector = ".navbar .container-fluid .navbar-collapse",
    ui = tags$ul(class = "nav navbar-nav navbar-right",
                 tags$li(
                   div(style = "padding: 10px; padding-top: 8px; padding-bottom: 0;",
                       shinyauthr::logoutUI("logout"))
                 ))
  )
  
  # Render the main map
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
      leafletProxy("mainMap") |>
        setView(lng = coords[1], lat = coords[2], zoom = 10)
    } else {
      leafletProxy("mainMap") |>
        setView(lng = -122.85, lat = 41.95, zoom = 7)
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
      proxy |>
        clearGroup("Basin Outline")
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
      proxy |>
        clearGroup("Sub-Basin Outline")
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
      leafletProxy("mainMap") |>
        clearGroup("Rotary Screw Traps")
    }
  })
  
  # Observer Hatcheries
  observe({
    if (input$show_hatcheries) {
      leafletProxy("mainMap") |>
        addMarkers(
          data = hatcheries,
          lng = ~longitude, lat = ~latitude,
          icon = ~rst_markers["H"],
          popup = ~paste("<em>Hatchery</em><br>", "Hatchery Name:", site_name),
          label = ~htmltools::HTML("<em>Hatchery</em>"),
          group = "Hatcheries"
        )
    } else {
      leafletProxy("mainMap") |>
        clearGroup("Hatcheries")
    }
  })
  
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_habitat_data) {
      proxy |> addMarkers(
        data = habitat_data,
        lng = ~longitude, lat = ~latitude,
        icon = ~rst_markers["X"],
        popup = ~paste0(
          "<em>Habitat Data</em><br>Model Type: ", model_type,
          "<br>Status: ", status, "<br>Location Name: ", location_name
        ),
        label = ~htmltools::HTML("<em>Habitat Data</em>"),
      )
    } else {
      proxy |> clearGroup("Habitat Data")
    }
  })
  
  # Observer for redd and carcass data
  # observe({
  #   proxy <- leafletProxy("mainMap")
  #   if (input$show_survey_type) {
  #     redd_data <- survey_type |> filter(adult_survey_type == "Redd")
  #     if (nrow(redd_data) > 0) {
  #       proxy |> addMarkers(
  #         data = redd_data,
  #         lng = ~longitude, lat = ~latitude,
  #         popup = ~paste("<em>Redd Adult Survey Reach</em><br>",
  #                        "Type of Survey: ", adult_survey_type, "<br>",
  #                        "Temporal Coverage: ", temporal_coverage, "<br>",
  #                        "<button onclick=\"window.open('", link, "', '_blank')\">More Information</button>"),
  #         label = ~htmltools::HTML("<em>Redd Survey</em>"),
  #         icon = ~reach_markers["010"],
  #         group = "Survey Data"
  #       )
  #     }
  #   } else {
  #     proxy |> clearGroup("Survey Data")
  #   }
  # })
  
  # Observer for surveyed river extent
  # observe({
  #   proxy <- leafletProxy("mainMap")
  #   if (input$show_surveyed_river_extent) {
  #     proxy |>
  #       addPolylines(data = surveyed_river_extent, 
  #                    color = "blue", 
  #                    weight = 2, 
  #                    group = "Survey extent")
  #   } else {
  #     proxy  |> 
  #       clearGroup("Survey extent")
  #   }
  # })
  
  # Observer for USGS Dam Removal Map
  # Observer for USGS Dam Removal Map
  observe({
    proxy <- leafletProxy("mainMap")
    if (!input$show_usgs_dam_layers) {
      proxy |>
        clearGroup("Dams to be Removed") |>
        clearGroup("Dams") |>
        clearGroup("Klamath River Corridor") |>
        clearGroup("Copco Reservoir") |>
        clearGroup("Estuary Bed Sediments") |>
        clearGroup("Iron Gate Reservoir") |>
        clearGroup("Geomorphic Reaches") |>
        clearGroup("Sediment Bug Samples") |>
        clearGroup("Stream Gages") |>
        clearGroup("Tributary Fingerprinting Samples")
    }
  })
  
  # Observer for toggling dams to be removed
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_dams_tb_removed) {
      proxy |>
        addCircleMarkers(data = dams_tb_removed, 
                         color = "red", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         label = ~htmltools::HTML("<em>Dams to be Removed</em>"), 
                         group = "Dams to be Removed")
    } else {
      proxy |>
        clearGroup("Dams to be Removed")
    }
  })
  
  # Observer for toggling dams
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_dams) {
      proxy |>
        addCircleMarkers(data = dams, 
                         color = "blue", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         label = ~htmltools::HTML("<em>Dams</em>"), 
                         group = "Dams")
    } else {
      proxy |>
        clearGroup("Dams")
    }
  })
  
  # Observer for Klamath River Corridor
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_kl_corridor) {
      proxy |>
        addPolylines(data = kl_corridor, color = "green", weight = 2, group = "Klamath River Corridor")
    } else {
      proxy |>
        clearGroup("Klamath River Corridor")
    }
  })
  # Observer to toggle "Copco Reservoir"
  
  
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_copco_res) {
      proxy |>
        addCircleMarkers(data = copco_res, 
                         color = "orange", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         label = ~htmltools::HTML("<em>Copco Reservoir</em>"), 
                         group = "Copco Reservoir")
    } else {
      proxy |> clearGroup("Copco Reservoir")
    }
  })
  
  # Observer to toggle "Estuary Bed Sediments"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_estuary_bedsed) {
      proxy |>
        addCircleMarkers(data = estuary_bedsed, 
                         color = "purple", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         label = ~htmltools::HTML("<em>Estuary Bed Sediments</em>"), 
                         group = "Estuary Bed Sediments")
    } else {
      proxy |> clearGroup("Estuary Bed Sediments")
    }
  })
  # Observer to toggle "Iron Gate Reservoir"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_ig_reservoir) {
      proxy |>
        addCircleMarkers(data = ig_reservoir, 
                         color = "cyan", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         label = ~htmltools::HTML("<em>Iron Gate Reservoir</em>"),
                         group = "Iron Gate Reservoir")
    } else {
      proxy |> clearGroup("Iron Gate Reservoir")
    }
  })
  
  # Observer to toggle "Geomorphic Reaches"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_geomorphic_reaches) {
      proxy |>
        addCircleMarkers(data = geomorphic_reaches, 
                         color = "brown", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                         label = ~htmltools::HTML("<em>Geomorphic Reaches</em>"),
                         group = "Geomorphic Reaches")
    } else {
      proxy |> clearGroup("Geomorphic Reaches")
    }
  })
  
  # Observer to toggle "Sediment Bug Samples"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_sediment_bug) {
      proxy |>
        addCircleMarkers(data = sediment_bug, 
                         color = "yellow", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                   label = ~htmltools::HTML("<em>Sediment Bug Samples</em>"), 
                   group = "Sediment Bug Samples")
    } else {
      proxy |> clearGroup("Sediment Bug Samples")
    }
  })
  
  # Observer to toggle "Stream Gages"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_stream_gages) {
      proxy |>
        addCircleMarkers(data = stream_gages, 
                         color = "black", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                   label = ~htmltools::HTML("<em>Stream Gages</em>"), 
                   group = "Stream Gages")
    } else {
      proxy |> clearGroup("Stream Gages")
    }
  })
  
  # Observer to toggle "Tributary Fingerprinting Samples"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_fingerprinting) {
      proxy |>
        addCircleMarkers(data = fingerprinting, 
                         color = "black", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                   label = ~htmltools::HTML("<em>Tributary Fingerprinting Samples</em>"),  
                   group = "Tributary Fingerprinting Samples")
    } else {
      proxy |> clearGroup("Tributary Fingerprinting Samples")
    }
  })
  
  
})

