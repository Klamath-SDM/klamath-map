monitoring_tab_ui <- function(id) {
  ns <- NS(id)
  # tabsetPanel(type = "tabs",
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
       h5("This map was developed to support the Klamath SDM effort led by US Bureau of Reclamation."),
        br(),
        selectInput(
          ns("zoom_select_river"),
          "Zoom to River",
          #c("(Default View)", sort(names(river_bounds)))
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
        ),
        
        hr(),
        
        tags$div(
          class = "legend-item",
          checkboxInput(
            ns("show_rst"),
            "Rotary Screw Traps",
            value = TRUE,
            width = NULL
          ),
          HTML(
            "<ul class='legend-list'>
                      <li><img src='icon-diamond.png' /> Single Trap</li>
                      <li><img src='icon-diamond-stack.png' /> Multiple Traps</li>
                 </ul>"
          ),
          p(class="legend-description", "Private rotary screw trap sites are illustrated as general vicinities (half mile radius).")
        ),
        
        tags$div(
          class = "legend-item",
          checkboxInput(
            ns("show_survey_reaches"),
            "Adult Survey Reaches",
            value = TRUE,
            width = NULL
          ),
          HTML(
            "<ul class='legend-list'>
                      <li><img src='icon-circle-100.png' /> Holding Surveys</li>
                      <li><img src='icon-circle-010.png' /> Redd Surveys</li>
                      <li><img src='icon-circle-001.png' /> Carcass Surveys</li>
                 </ul>"
          ),
          HTML(
            "<p class=legend-description>Reach midpoints are shown; zoom in to see <img src='icon-x.png' style='height:1em;'/> reach breaks and footprints where data is available. Select to filter:</p>"
          ),
          tags$div(class = "legend-item-options", selectInput(
            ns("select_adult_survey_type"),
            "Select Survey Type",
            c("(All Survey Types)", "Holding", "Redd", "Carcass")
          )),
        ),
        
        tags$div(
          class = "legend-item",
          checkboxInput(
            ns("show_video_mon"),
            htmltools::HTML("<img src='icon-video.png' /> Upstream Passage Video Systems"),
            value = TRUE,
            width = NULL
          ),
          p(
            class = "legend-description",
            "VAKI video monitoring system locations are illustrated as general vicinities (half mile radius)."
          )
        ),
        
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
        ),
        
        tags$div(
          class = "legend-item",
          checkboxInput(
            ns("show_hatcheries"),
            htmltools::HTML("<img src='icon-spiral.png' /> Fish Hatcheries"),
            value = TRUE,
            width = NULL
          ),
          # p(class="legend-description", "Fish hatchery description here")
        ),
        
        tags$div(
          class = "legend-item",
          checkboxInput(
            ns("show_habitat"),
            "Stream Habitat",
            value = TRUE,
            width = NULL
          ),
          tags$ul(
            class = 'legend-list',
            tags$li(
              checkboxInput(
                ns("show_habitat_s"),
                htmltools::HTML(
                  "<img src='legend-habitat-2.png' /> Spring Run Chinook Spawning Habitat"
                ),
                value = TRUE,
                width = NULL
              )
            ),
            tags$li(
              checkboxInput(
                ns("show_habitat_r"),
                htmltools::HTML(
                  "<img src='legend-habitat-1.png' /> Spring-Run Chinook Rearing Habitat"
                ),
                value = TRUE,
                width = NULL
              )
            ),
            tags$li(
              checkboxInput(
                ns("show_habitat_o"),
                htmltools::HTML(
                  "<img src='legend-habitat-3.png' /> Accessible Salmonid Extents"
                ),
                value = TRUE,
                width = NULL
              )
            ),
          ),
          HTML(
            "<p class='legend-description'>The habitat extents displayed on the map ... </p>"
          )
        ),
        
        # tags$div(class="legend-item",
        #          checkboxInput("show_bypasses", htmltools::HTML("<img src='legend-bypass.png' /> Flood Bypasses"), value = TRUE, width = NULL),
        #          p(class="legend-description", "Flood bypass description here")
        # ),
        
        #tags$div(class="legend-item",
        #         checkboxInput("show_watersheds", "Watersheds", value = TRUE, width = NULL),
        #       p(class="legend-description", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
        #    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        #    quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
        #),
        
      ),
      
      mainPanel(fluidRow(leafletOutput(ns("mainMap"))))
    )
  )
  # ),
  # tabPanel("Reference",
  #          #HTML("<iframe class=reference-doc src=https://docs.google.com/document/d/1as6af_NwmaNZ9H9zN9MT9A11w8svoGmNQbye5a7k6KY/preview>"),
  #          tags$div(class="reference-content",
  #                   HTML("<p><strong>External resources</strong></p>"),
  #                   tags$ul(tags$li(HTML("<a href=https://water.ca.gov/Programs/State-Water-Project/Endangered-Species-Protection target=_blank>DWR State Water Project Incidental Take Permit landing page</a>"))))
  # ),)
  
}

# monitoring_tab_server <- function(id) {
#   moduleServer(id,
#                function(input, output, session) {
#                  # Define the non-reactive portion of the Leaflet map
#                  output$mainMap <- renderLeaflet({
#                    leaflet() |>
#                      leaflet::addMapPane("Basemap", zIndex = 400) |>
#                      leaflet::addMapPane("Polygons", zIndex = 450) |>
#                      leaflet::addMapPane("Radius-Video", zIndex = 451) |>
#                      leaflet::addMapPane("Lines-Habitat", zIndex = 460) |>
#                      leaflet::addMapPane("Lines-Survey", zIndex = 470) |>
#                      leaflet::addMapPane("Points-Survey", zIndex = 481) |>
#                      leaflet::addMapPane("Points-RST", zIndex = 482) |>
#                      leaflet::addMapPane("Points-Temp", zIndex = 483) |>
#                      leaflet::addMapPane("Points-Video", zIndex = 484) |>
#                      leaflet::addMapPane("Points-Hatcheries", zIndex = 485) |>
#                      leaflet::addMapPane("Reference", zIndex = 490) |>
#                      addTiles(
#                        urlTemplate = 'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}',
#                        attribution = 'Basemap tiles &copy; Esri &mdash; Sources: GEBCO, NOAA, CHS, OSU, UNH, CSUMB, National Geographic, DeLorme, NAVTEQ, and Esri',
#                        options = tileOptions(
#                          noWrap = TRUE,
#                          opacity = 1,
#                          maxNativeZoom = 13,
#                          maxZoom = 13,
#                          pane = "Basemap"
#                        )
#                      ) |>
#                      addTiles(
#                        urlTemplate = 'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Reference_Overlay/MapServer/tile/{z}/{y}/{x}',
#                        attribution = 'Reference tiles &copy; Esri &mdash; Source: USGS, Esri, TANA, DeLorme, and NPS',
#                        options = tileOptions(
#                          noWrap = TRUE,
#                          opacity = 1,
#                          minZoom = 10,
#                          maxNativeZoom = 13,
#                          maxZoom = 13,
#                          pane = "Reference"
#                        )
#                      ) |>
#                      addTiles(
#                        urlTemplate = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
#                        attribution = 'Imagery tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
#                        options = tileOptions(
#                          noWrap = TRUE,
#                          opacity = 0.5,
#                          minZoom = 14,
#                          maxNativeZoom = 23,
#                          pane = "Basemap"
#                        )
#                      ) |>
#                      groupOptions("Wide Only", zoomLevels = 4:13) |>
#                      groupOptions("Detail Only", zoomLevels = 14:22) |>
#                      groupOptions("Obscured Points", zoomLevels = 4:10) |>
#                      groupOptions("Obscured Radius", zoomLevels = 11:22) |>
#                      #groupOptions("Obscured Points Wide Only")
#                      # TODO - we may need to adjust these
#                      fitBounds(
#                        lng1 = bbox[["xmin"]],
#                        lat1 = bbox[["ymin"]],
#                        lng2 = bbox[["xmax"]],
#                        lat2 = bbox[["ymax"]]
#                      )
#                  })
#                  
#                  # ROTARY SCREW TRAPS
#                  observeEvent(input$show_rst, {
#                    # req(input$show_rst)
#                    proxy_rst <- leafletProxy("mainMap")
#                    if (input$show_rst) {
#                      proxy_rst |>
#                        addMarkers(
#                          data = rst_sites, # TODO this is where we need to add lat/long data for RST sites from Willie
#                          layerId = ~ uid,
#                          label = ~ lapply(if_else(
#                            !is.na(image_embed),
#                            paste0(
#                              popup,
#                              "<p><strong>Click for more details &rarr;</strong></p>"
#                            ),
#                            popup
#                          ), htmltools::HTML),
#                          #label = ~lapply(paste0(popup,"<p><em>(click for details)</em></p>"),htmltools::HTML),
#                          #label = ~lapply(if_else(!is.na(image_embed),paste0(image_embed,popup),popup),htmltools::HTML),
#                          popup = ~ if_else(
#                            !is.na(image_embed),
#                            paste0(image_embed, popup),
#                            popup
#                          ),
#                          #popup = ~if_else(!is.na(image_embed),paste0(popup,image_embed),popup),
#                          group = "Wide Only",
#                          icon = ~ rst_markers[marker_type]
#                        ) |>
#                        addMarkers(
#                          data = rst_trap_locations,
#                          layerId = ~ uid,
#                          label = ~ lapply(popup, htmltools::HTML),
#                          popup = ~ popup,
#                          group = "Detail Only",
#                          icon = ~ rst_markers["single"]
#                        )
#                    } else {
#                      proxy_rst |>
#                        removeMarker(rst_sites$uid) |>
#                        removeMarker(rst_trap_locations$uid)
#                    }
#                  })
#                  
#                  # ADULT SURVEY REACHES
#                  observeEvent(c(
#                    input$show_survey_reaches,
#                    input$select_adult_survey_type
#                  ),
#                  {
#                    proxy_survey_reaches <- leafletProxy("mainMap")
#                    if (input$show_survey_reaches) {
#                      if (input$select_adult_survey_type == "(All Survey Types)") {
#                        proxy_survey_reaches |>
#                          removeMarker(survey_reaches$uid) |>
#                          addMarkers(
#                            data = survey_reaches, # TODO update data for redd, carcass survey data
#                            layerId = ~ uid,
#                            icon = ~ reach_markers[typecode],
#                            label = ~ lapply(popup, htmltools::HTML),
#                            popup = ~ popup,
#                            options = leaflet::markerOptions(pane = "Points-Survey")
#                          ) |>
#                          removeShape(survey_reach_detail$uid) |>
#                          removeMarker(survey_reach_breaks$uid)
#                        if (nrow(survey_reach_detail) > 0) {
#                          proxy_survey_reaches |>
#                            addPolygons(
#                              data = survey_reach_detail, # TODO update data
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              color = "black",
#                              opacity = 1,
#                              weight = 1,
#                              fillOpacity = 0,
#                              options = leaflet::pathOptions(pane = "Lines-Survey")
#                            )
#                        }
#                        if (nrow(survey_reach_breaks) > 0) {
#                          proxy_survey_reaches |>
#                            addMarkers(
#                              data = survey_reach_breaks,# TODO update data
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              icon = ~ rst_markers["X"],
#                              options = leaflet::markerOptions(pane = "Lines-Survey")
#                            )
#                        }
#                      } else if (input$select_adult_survey_type == "Redd") {
#                        proxy_survey_reaches |>
#                          removeMarker(survey_reaches$uid) |>
#                          addMarkers(
#                            data = survey_reaches |> filter(has_redd),
#                            layerId = ~ uid,
#                            icon = ~ reach_markers["010"],
#                            label = ~ lapply(popup, htmltools::HTML),
#                            popup = ~ popup,
#                            options = leaflet::markerOptions(pane = "Points-Survey")
#                          ) |>
#                          removeShape(survey_reach_detail$uid) |>
#                          removeMarker(survey_reach_breaks$uid)
#                        if (nrow(survey_reach_detail |> filter(has_redd)) > 0) {
#                          proxy_survey_reaches |>
#                            addPolygons(
#                              data = survey_reach_detail |> filter(has_redd),
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              color = "black",
#                              opacity = 1,
#                              weight = 1,
#                              fillOpacity = 0,
#                              options = leaflet::pathOptions(pane = "Lines-Survey")
#                            )
#                        }
#                        if (nrow(survey_reach_breaks |> filter(has_redd)) > 0) {
#                          proxy_survey_reaches |>
#                            addMarkers(
#                              data = survey_reach_breaks |> filter(has_redd),
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              icon = ~ rst_markers["X"],
#                              options = leaflet::markerOptions(pane = "Lines-Survey")
#                            )
#                        }
#                      } else if (input$select_adult_survey_type == "Carcass") {
#                        proxy_survey_reaches |>
#                          removeMarker(survey_reaches$uid) |>
#                          addMarkers(
#                            data = survey_reaches |> filter(has_carcass),
#                            layerId = ~ uid,
#                            icon = ~ reach_markers["001"],
#                            label = ~ lapply(popup, htmltools::HTML),
#                            popup = ~ popup,
#                            options = leaflet::markerOptions(pane = "Points-Survey")
#                          ) |>
#                          removeShape(survey_reach_detail$uid) |>
#                          removeMarker(survey_reach_breaks$uid)
#                        if (nrow(survey_reach_detail |> filter(has_carcass)) > 0) {
#                          proxy_survey_reaches |>
#                            addPolygons(
#                              data = survey_reach_detail |> filter(has_carcass),
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              color = "black",
#                              opacity = 1,
#                              weight = 1,
#                              fillOpacity = 0,
#                              options = leaflet::pathOptions(pane = "Lines-Survey")
#                            )
#                        }
#                        if (nrow(survey_reach_breaks |> filter(has_carcass)) > 0) {
#                          proxy_survey_reaches |>
#                            addMarkers(
#                              data = survey_reach_breaks |> filter(has_carcass),
#                              layerId = ~ uid,
#                              label = ~ lapply(popup, htmltools::HTML),
#                              popup = ~ popup,
#                              group = "Detail Only",
#                              icon = ~ rst_markers["X"],
#                              options = leaflet::markerOptions(pane = "Lines-Survey")
#                            )
#                        }
#                      }
#                    } else {
#                      proxy_survey_reaches |>
#                        removeMarker(survey_reaches$uid) |>
#                        removeShape(survey_reach_detail$uid) |>
#                        removeMarker(survey_reach_breaks$uid)
#                    }
#                  })
                 
                 # TEMPERATURE LOGGERS
                 observeEvent(input$show_temp_loggers, {
                   proxy_temp_loggers <- leafletProxy("mainMap")
                   if (input$show_temp_loggers) {
                     proxy_temp_loggers |>
                       addMarkers(
                         data = temp_loggers, # TODO update data
                         layerId = ~ uid,
                         icon = ~ rst_markers["T"],
                         label = ~ lapply(popup, htmltools::HTML),
                         popup = ~ popup,
                         options = leaflet::markerOptions(pane = "Points-Temp")
                       ) |>
                       addMarkers(
                         data = gages_cdec_usgs, # TODO update data
                         layerId = ~ uid,
                         icon = ~ rst_markers[case_when(
                           flow_gage & temp_gage ~ "circle-TF",
                           flow_gage ~ "circle-F",
                           temp_gage ~ "circle-T"
                         )],
                         label = ~ lapply(popup, htmltools::HTML),
                         popup = ~ paste0(
                           popup,
                           "<p><a href=",
                           url,
                           " target=_blank><strong>Click to open gage page &rarr;</strong></a></p>"
                         ),
                         options = leaflet::markerOptions(pane = "Points-Temp")
                       )
                   } else {
                     proxy_temp_loggers |>
                       removeMarker(temp_loggers$uid) |>
                       removeMarker(gages_cdec_usgs$uid)
                   }
                 })
                 
               #   # VIDEO MONITORS
               #   observeEvent(input$show_video_mon, {
               #     proxy_video_mon <- leafletProxy("mainMap")
               #     if (input$show_video_mon) {
               #       proxy_video_mon |>
               #         addMarkers(
               #           data = video_mon,# TODO update data
               #           layerId = ~ uid,
               #           icon = ~ rst_markers["video"],
               #           label = ~ lapply(popup, htmltools::HTML),
               #           popup = ~ popup,
               #           group = "Obscured Points",
               #           options = leaflet::markerOptions(pane = "Points-Video")
               #         ) |>
               #         addPolygons(
               #           data = video_mon_circle,
               #           layerId = ~ uid,
               #           label = ~ lapply(popup, htmltools::HTML),
               #           fillColor = "#555555",
               #           color = "#555555",
               #           weight = 1,
               #           opacity = 0.5,
               #           popup = ~ popup,
               #           group = "Obscured Radius",
               #           options = leaflet::markerOptions(pane = "Radius-Video")
               #         )
               #     } else {
               #       proxy_video_mon |>
               #         removeMarker(video_mon$uid) |>
               #         removeShape(video_mon_circle$uid)
               #     }
               #   })
               #   
               #   # SIT HABITAT EXTENTS
               #   observeEvent(
               #     c(
               #       input$show_habitat,
               #       input$show_habitat_o,
               #       input$show_habitat_r,
               #       input$show_habitat_s
               #     ),
               #     {
               #       proxy_habitat <- leafletProxy("mainMap")
               #       if (input$show_habitat) {
               #         if (input$show_habitat_o) {
               #           proxy_habitat |>
               #             addPolylines(
               #               data = other_habitat, # TODO update data
               #               layerId = ~ uid,
               #               label = ~ lapply(popup, htmltools::HTML),
               #               # for hover function, use ~lapply(popup,htmltools::HTML)
               #               popup = ~ popup,
               #               color = "#99B3CC",
               #               # 8CC2CA 6388B4
               #               opacity = 1,
               #               weight = 3,
               #               group = "Wide Only",
               #               options = leaflet::pathOptions(pane = "Lines-Habitat"),
               #               #highlightOptions = leaflet::highlightOptions(color = "white", #color = "#FDD20E",
               #               #                                             weight = 2,
               #               #                                             bringToFront = FALSE)
               #             )
               #         } else {
               #           proxy_habitat |>
               #             removeShape(other_habitat$uid)
               #         }
               #         if (input$show_habitat_r) {
               #           proxy_habitat |>
               #             addPolylines(
               #               data = rearing_habitat, # TODO update data
               #               layerId = ~ uid,
               #               label = ~ lapply(popup, htmltools::HTML),
               #               popup = ~ popup,
               #               color = "#BB7693",
               #               opacity = 1,
               #               weight = 3,
               #               group = "Wide Only",
               #               options = leaflet::pathOptions(pane = "Lines-Habitat"),
               #               #highlightOptions = leaflet::highlightOptions(color = "white", #color = "#FDD20E",
               #               #                                             weight = 2,
               #               #                                             bringToFront = FALSE)
               #             ) |>
               #             addPolygons(
               #               data = bypasses, # TODO update data
               #               layerId = ~ uid,
               #               label = ~ lapply(popup, htmltools::HTML),
               #               popup = ~ popup,
               #               opacity = 0,
               #               fillColor = "#BB7693",
               #               fillOpacity = 0.5,
               #               group = "Wide Only",
               #               options = leaflet::pathOptions(pane = "Polygons"),
               #             )
               #         } else {
               #           proxy_habitat |>
               #             removeShape(rearing_habitat$uid) |>
               #             removeShape(bypasses$uid)
               #         }
               #         if (input$show_habitat_s) {
               #           proxy_habitat |>
               #             addPolylines(
               #               data = spawning_habitat, # TODO update data
               #               layerId = ~ uid,
               #               label = ~ lapply(popup, htmltools::HTML),
               #               popup = ~ popup,
               #               color = "#FFAE34",
               #               opacity = 1,
               #               weight = 3,
               #               dashArray = "4, 4",
               #               group = "Wide Only",
               #               options = leaflet::pathOptions(pane = "Lines-Habitat"),
               #               #highlightOptions = leaflet::highlightOptions(color = "white", #color = "#FDD20E",
               #               #                                             weight = 2,
               #               #                                             bringToFront = FALSE)
               #             )
               #         } else {
               #           proxy_habitat |>
               #             removeShape(spawning_habitat$uid)
               #         }
               #       } else {
               #         proxy_habitat |>
               #           removeShape(salmonid_habitat_extents$uid) |>
               #           removeShape(bypasses$uid)
               #         
               #       }
               #     }
               #   )
               #   
               #   observeEvent(input$show_hatcheries, {
               #     proxy <- leafletProxy("mainMap")
               #     if (input$show_hatcheries) {
               #       proxy |>
               #         addMarkers(
               #           data = hatcheries, # TODO update data
               #           layerId = ~ uid,
               #           icon = ~ rst_markers["H"],
               #           label = ~ lapply(popup, htmltools::HTML),
               #           popup = ~ popup,
               #           options = leaflet::pathOptions(pane = "Points-Hatcheries"),
               #         )
               #     } else {
               #       proxy |>
               #         removeMarker(hatcheries$uid)
               #     }
               #     
               #   })
               #   
               #   observeEvent(input$zoom_select_river, {
               #     proxy_setview <- leafletProxy("mainMap")
               #     if (input$zoom_select_river == "(Default View)") {
               #       proxy_setview |> fitBounds(
               #         lng1 = bbox[["xmin"]],
               #         lat1 = bbox[["ymin"]],
               #         lng2 = bbox[["xmax"]],
               #         lat2 = bbox[["ymax"]]
               #       )
               #     } else {
               #       proxy_setview |> fitBounds(
               #         lng1 = river_bounds[[input$zoom_select_river]][["xmin"]],
               #         lat1 = river_bounds[[input$zoom_select_river]][["ymin"]],
               #         lng2 = river_bounds[[input$zoom_select_river]][["xmax"]],
               #         lat2 = river_bounds[[input$zoom_select_river]][["ymax"]]
               #       )
               #     }
               #   })
               # })
# }

# 