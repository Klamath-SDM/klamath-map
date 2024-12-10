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
    "Williamson" = c(-121.89, 42.937),          
    "Sprague" = c(-121.356, 42.354),              
    "Upper Klamath Lake" = c(-121.79, 42.5),  
    "Butte" = c(-121.9, 41.7),                
    "Shasta" = c(-122.41, 41.7),              
    "Scott" = c(-123.0, 41.55),               
    "Lower Klamath" = c( -123.4, 41.6),       
    "Salmon" = c(-123.4, 41.3),               
    "Trinity" = c(-123.1, 41.0),              
    "South Fork Trinity" = c(-123.5, 40.5),   
    "Lost" = c(-121.56, 42.0)                 
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
  
  
  # observe({
  #   proxy <- leafletProxy("mainMap")
  #   if (input$show_survey_lines) {
  #     # Check if geometry is valid
  #     if (!is.null(survey_lines)) {
  #       # Create a color palette
  #       color_palette <- colorFactor(
  #         palette = c("red", "blue", "green", "purple"), 
  #         domain = survey_lines$data_type
  #       )
  #       
  #       # Add polylines to the map
  #       proxy |>
  #         addPolylines(
  #           data = survey_lines,
  #           color = ~color_palette(data_type),
  #           weight = 2,
  #           opacity = 0.8,
  #           label = ~paste(data_type, "Reach"),
  #           popup = ~paste(
  #             "<em>Reach Temp-name</em><br>", 
  #             "Reach-Temp Name:", data_type
  #           ),
  #           group = "Redd-Test"
  #         )
  #     }
  #   } else {
  #     # Clear the group if the checkbox is unchecked
  #     proxy |> clearGroup("Redd-Test")
  #   }
  # })
  
  # Observer to manage stream lines
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_streams) {
      proxy |>
        addPolylines(
          data = streams,
          color = "blue",
          weight = 2,
          opacity = 0.8,
          fillOpacity = 0.5,
          label = ~paste(Label, "Stream"),
          popup = ~paste("<em>Stream</em><br>", "Stream Name:", Label),
          group = "Streams"
        )
    } else {
      proxy |>
        clearGroup("Streams")
    }
  })
  
  # Observer to manage temperature and flow gages display
  observe({
    proxy <- leafletProxy("mainMap") 
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
          label = ~htmltools::HTML("<em>USGS Flow Gage</em>"),
          group = "USGS Gages"
        ) |> 
        addMarkers(
          data = temperature,
          lng = ~longitude, lat = ~latitude, 
          icon = ~rst_markers["circle-T"],
          popup = ~paste("<em>Temperature Gage</em><br>", "Gage Number:", gage_number, 
                         "<br>Latest Date:", latest_data, "<br>Earliest Date:", earliest_data,
                         "<button onclick=\"window.open('https://waterdata.usgs.gov/nwis/inventory?site_no=", 
                         gage_number, "', '_blank')\">Gage Site</button>"),
          label = ~htmltools::HTML("<em>USGS Temperature Gage</em>"),
          group = "USGS Gages"
        )
    } else {
      proxy |>
        clearGroup("USGS Gages")
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
                         "<br><button onclick='window.open(\"", link, "\", \"_blank\")'>More Info</button>"),
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
          popup = ~paste(
            "<em>Hatchery</em><br>",
            "Hatchery Name:", site_name, 
            "<br><button onclick='window.open(\"", resource, "\", \"_blank\")'>More Info</button>"
          ),
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
        group = "Habitat Data"
      )
    } else {
      proxy |> clearGroup("Habitat Data")
    }
  })
  
  # Observer for redd and carcass data

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
  
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_survey_points) {
      proxy |> addMarkers(data = survey_points, 
                          lng = ~longitude, lat = ~latitude,
                          icon = ~rst_markers["square"],
                          popup = ~paste("<em>Redd/Carcas Surveys</em><br>", "Survey Type:", data_type, "<br>Survery year(s):", temporal_coverage,
                                         "<br>Species:", species,
                                         "<br>Source:", agency,
                                         "<br><button onclick=\"window.open('", 
                                         ifelse(Id >= 14 & Id <= 17, "klamath_fish_kill_2002.pdf", 
                                                ifelse(Id >= 21 & Id <= 27, "klamath_spawning_2008.pdf", "#")), 
                                         "','_blank')\">Most Recent Report</button>"),
                          label = ~htmltools::HTML("<em>Redd/Carcas Surveys</em>"), 
                          group = "Redd/Carcas Surveys")
    } else {
      proxy |>
        clearGroup("Redd/Carcas Surveys")
    }
  })
  
  # Observer for USGS Dam Removal Map
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_dams_tb_removed) {
        proxy |> addCircleMarkers(data = dams_tb_removed, 
                         color = "red", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Dams to be Removed</em>",
                                        "<br>Dam Name:", DAM_NAME,
                                        "<br>Source: USGS Dam Removal Map"),
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
    if (input$show_usgs_dam_layers && input$show_dams) {
      proxy |>
        addCircleMarkers(data = dams, 
                         color = "blue", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Dams</em>",
                                        "<br>Dam Name:", DAM_NAME,
                                        "<br>Source: USGS Dam Removal Map"),
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
    if (input$show_usgs_dam_layers && input$show_kl_corridor) {
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
    if (input$show_usgs_dam_layers && input$show_copco_res) {
      proxy |>
        addCircleMarkers(data = copco_res, 
                         color = "orange", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Copco Reservoir</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                         label = ~htmltools::HTML("<em>Copco Reservoir</em>"), 
                         group = "Copco Reservoir")
    } else {
      proxy |> clearGroup("Copco Reservoir")
    }
  })
  
  # Observer to toggle "Estuary Bed Sediments"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_estuary_bedsed) {
      proxy |>
        addCircleMarkers(data = estuary_bedsed, 
                         color = "purple", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Estuary Bed Sediments</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                         label = ~htmltools::HTML("<em>Estuary Bed Sediments</em>"), 
                         group = "Estuary Bed Sediments")
    } else {
      proxy |> clearGroup("Estuary Bed Sediments")
    }
  })
  # Observer to toggle "JCBoyle Reservoir Bed Sediment Cores"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_jc_boyle_reservoir_bedsed) {
      proxy |>
        addCircleMarkers(data = jc_boyle_reservoir_bedsed, 
                         color = "cyan", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>JCBoyle Reservoir Bed Sediment Cores</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                         label = ~htmltools::HTML("<em>JCBoyle Reservoir Bed Sediment Cores</em>"),
                         group = "JCBoyle Reservoir Bed Sediment Cores")
    } else {
      proxy |> clearGroup("JCBoyle Reservoir Bed Sediment Cores")
    }
  })
  # Observer to toggle "Iron Gate Reservoir bed sediment cores"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_ig_reservoir_bedsed) {
      proxy |>
        addCircleMarkers(data = ig_reservoir_bedsed, 
                         color = "lavender", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Iron Gate Reservoir Bed Sediment Cores</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                         label = ~htmltools::HTML("<em>Iron Gate Reservoir</em>"),
                         group = "Iron Gate Reservoir Bed Sediment Cores")
    } else {
      proxy |> clearGroup("Iron Gate Reservoir Bed Sediment Cores")
    }
  })
  
  # Observer to toggle "Geomorphic Reaches"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_geomorphic_reaches) {
      proxy |>
        addCircleMarkers(data = geomorphic_reaches, 
                         color = "brown", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                         popup = ~paste("<em>Geomorphic Reaches</em>",
                                        "<br>Name:", Name,
                                        "<br>Source: USGS Dam Removal Map"),
                         label = ~htmltools::HTML("<em>Geomorphic Reaches</em>"),
                         group = "Geomorphic Reaches")
    } else {
      proxy |> clearGroup("Geomorphic Reaches")
    }
  })
  
  # Observer to toggle "Sediment Bug Samples"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_sediment_bug) {
      proxy |>
        addCircleMarkers(data = sediment_bug, 
                         color = "yellow", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5,
                         popup = ~paste("<em>Invertebrate and Bed Sediment Samples</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                   label = ~htmltools::HTML("<em>Sediment Bug Samples</em>"), 
                   group = "Sediment Bug Samples")
    } else {
      proxy |> clearGroup("Sediment Bug Samples")
    }
  })
  
  # Observer to toggle "Stream Gages"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_stream_gages) {
      proxy |>
        addCircleMarkers(data = stream_gages, 
                         color = "black", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                         popup = ~paste("<em>Stream Gages</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                   label = ~htmltools::HTML("<em>Stream Gages</em>"), 
                   group = "Stream Gages")
    } else {
      proxy |> clearGroup("Stream Gages")
    }
  })
  
  # Observer to toggle "Tributary Fingerprinting Samples"
  observe({
    proxy <- leafletProxy("mainMap")
    if (input$show_usgs_dam_layers && input$show_fingerprinting) {
      proxy |>
        addCircleMarkers(data = fingerprinting, 
                         color = "lightgreen", 
                         fillOpacity = 0.7, 
                         weight = 2, 
                         radius = 5, 
                         popup = ~paste("<em>Tributary Fingerprinting Samples</em>",
                                        "<br>Source: USGS Dam Removal Map"),
                   label = ~htmltools::HTML("<em>Tributary Fingerprinting Samples</em>"),  
                   group = "Tributary Fingerprinting Samples")
    } else {
      proxy |> clearGroup("Tributary Fingerprinting Samples")
    }
  })
})

