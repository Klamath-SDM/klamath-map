library(shiny)
library(shinyjs)
library(leaflet)
library(DT)

ui <- fluidPage(
  style = "overflow-y: auto; height: 100vh;",
  tags$head(
    tags$style(HTML("
      .title-panel-text {
        font-size: 36px;
        font-weight: normal;
        color: black;
        text-align: center;
        padding: 10px 20px;
        border-radius: 8px;
      }
    ")),
  
  tags$script(HTML("
    $(document).on('click', '.action-btn', function() {
      var lat = $(this).data('latitude');
      var lng = $(this).data('longitude');
      var coords = lat + ',' + lng;
      Shiny.setInputValue('map_click', coords, {priority: 'event'});
    });"))
  ),
  
  div(class = "title-panel",
      div(class = "title-panel-text", "Klamath Basin Monitoring Map")
),
  
  # MAP PANEL
  tabsetPanel(
    tabPanel(
      "Monitoring Site Map",
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$script(src = "scripts/lightbox/js/lightbox.js"),
        tags$link(rel = "stylesheet", type = "text/css", href = "scripts/lightbox/css/lightbox.css")
      ),
      
      sidebarLayout(
        sidebarPanel(width = 3,
          h5("There is a wealth of data about water and ecological resources in the Klamath Basin collected over multiple decades by many entities. The high volume and dispersed nature of these data make it challenging to quickly determine data availability. This map was developed to support the Klamath Basin Science Collaborative by summarizing the data being collected in the Basin."),
          br(),
          # Select Input for Zooming to Rivers
          selectInput(
            "zoom_select_river", 
            "Zoom to Basin",
            c("(Default View)",
              sort(c("Williamson",
                     "Sprague",
                     "Upper Klamath Lake",
                     "Butte",
                     "Shasta",
                     "Scott",
                     "Lower Klamath",
                     "Salmon",
                     "Trinity",
                     "South Fork Trinity",
                     "Lost")
                   )
              )
            ),
          
          hr(),
          
          # Basin Outline
          # checkboxInput("show_basin_outline", "Klamath River Basin Outline", value = TRUE),
          checkboxInput("show_sub_basin_outline", "Klamath Sub Basin Boundaries", value = TRUE),
          checkboxInput("show_streams", "Klamath Basin Streams", value = TRUE),
          
          hr(),
          
          # Water Quality
          tags$div(
            class = "legend-item",
            checkboxInput("show_water_quality", "Water Quality", value = TRUE)
            ),
          conditionalPanel(
            condition = "input.show_water_quality == true", 
            tags$div(
              style = "margin-left: 20px;",
              checkboxInput("show_temp_gages", HTML("<span><img src='icon-circle-t.png' style='width: 20px; height: 20px;'/> Temperature gage</span>"), value = TRUE),
              checkboxInput("show_flow_gages", HTML("<span><img src='icon-circle-f.png' style='width: 20px; height: 20px;'/> Flow gage</span>"), value = TRUE),
              checkboxInput("show_do_gages", HTML("<span><img src='icon-circle-do.png' style='width: 20px; height: 20px;'/> DO gage</span>"), value = TRUE),
              checkboxInput("show_ph_gages", HTML("<span><img src='ph-icon.png' style='width: 20px; height: 20px; '></i> pH gage</span>"), value = TRUE)
              )
            ),
          
          p(class = "legend-description", "Data was sources from USGS and WQX gages. It was processed and synthesized using
            FlowWest KlamathWaterData R package. Find more information",
          tags$a(href = 'https://github.com/Klamath-SDM/klamathWaterData', 
                 "here", target = "_blank")),
          
          hr(),
          
          # Salmonid Data
          tags$div(
            class = "legend-item",
            checkboxInput("show_salmonid_data", "Salmonid Data", value = TRUE)),
          conditionalPanel(
            condition = "input.show_salmonid_data == true",
            tags$div(
              style = "margin-left: 20px;",
              checkboxInput("show_rst", HTML(" <span>RST Traps</span>
              <ul style='list-style-type: none; margin: 0; padding-left: 0;'>
              <li><img src='icon-diamond.png' style='width: 20px; height: 20px;' /> Single Trap</li>
              <li><img src='icon-diamond-stack.png' style='width: 20px; height: 20px;' /> Multiple Traps</li>
                                             </ul>"), value = TRUE),
              checkboxInput("show_survey_layers", "Redd/Carcass Survey Layers", value = TRUE),
              HTML("<img src='legend-habitat-1.png' style='width: 20px; height: 20px;' /> Redd/Carcass Survey Reaches"),
              HTML("<div style='display: block; margin-top: 5px;'>
                   <img src='legend-bypass.png' style='width: 20px; height: 20px;' /> Redd/Carcass Survey Points</div>"),
              
              # Fish Hatcheries
              checkboxInput("show_hatcheries", "Hatcheries", value = TRUE),
              HTML("<img src='icon-spiral.png' style='width: 20px; height: 20px;' /> Fish Hatcheries")
              )
            ),
          p(class = "legend-description", "Legend here"),
          
          hr(),
          
          # Habitat Models
          
          tags$div(
            class = "legend-item",
            checkboxInput("show_habitat_data", "Habitat Models", value = TRUE)
            ),
          conditionalPanel(
            condition = "input.show_habitat_data == true",
            tags$div(
              style = "margin-left: 20px; display: flex; align-items: center; gap: 10px;",
              checkboxInput("show_habitat_data_detail", 
                            HTML("<div><img src='icon-x.png' style='width: 20px; height: 20px; vertical-align: middle;' />Habitat Data</div>"), value = TRUE)
              )
            ),
          p(class = "legend-description", "Some models were already developed, some are being developed now. For more detailed data exploration information click ",
            tags$a(href = 'https://github.com/Klamath-SDM/Klamath-map/blob/add-gages/data-raw/habitat_summary.md', 
                   "here", target = "_blank")),
          
          hr(),
          
          # Species Habitat Extents Map Layers ---
          tags$div(
            class = "legend-item",
            checkboxInput("show_habitat_extent", "Fish Habitat Extents", value = TRUE)
            ),
          conditionalPanel(
            condition = "input.show_habitat_extent == true",
            tags$div(
              style = "margin-left: 20px;",
              checkboxInput("show_chinook_extent", HTML("<span><img src='legend-abundance-1.png' style='width: 20px; height: 20px;'/> Chinook Habitat Extent</span>"), value = TRUE),
              checkboxInput("show_coho_extent", HTML("<span><img src='legend-abundance-2.png' style='width: 20px; height: 20px;'/> Coho Habitat Extent</span>"), value = TRUE),
              checkboxInput("show_steelhead_extent", HTML("<span><img src='legend-abundance-3.png' style='width: 20px; height: 20px;'/> Steelhead Habitat Extent</span>"), value = TRUE)
              )
            ),
          
          p(class = "legend-description", "These layers were sourced from",
            tags$a(href = 'https://gis.data.ca.gov/', 
                   "California State Geoportal", target = "_blank")
            ),
          
          hr(),
          
          # USGS Dam Removal Map Layers
          #TODO figure out why mainbox disappears
          tags$div(
            class = "legend-item",
            checkboxInput("show_usgs_dam_layers", "USGS Dam Removal Monitoring Map Layers", value = TRUE)
            ),
          conditionalPanel(
            condition = "input.show_usgs_dam_layers == true",
            tags$div(
              style = "margin-left: 20px;",
              checkboxInput("show_dams_tb_removed", HTML("<span style='color:red;'>&#9673;</span> Removed Dams"), value = TRUE),
              checkboxInput("show_dams", HTML("<span style='color:blue;'>&#9673;</span> Existing Dams"), value = TRUE),
              checkboxInput("show_copco_res", HTML("<span style='color:orange;'>&#9673;</span> Copco Reservoir Bed Sediment Cores"), value = TRUE),
              checkboxInput("show_estuary_bedsed", HTML("<span style='color:purple;'>&#9673;</span> Estuary Bed Sediment Samples"), value = TRUE),
              checkboxInput("show_jc_boyle_reservoir_bedsed", HTML("<span style='color:cyan;'>&#9673;</span> JCBoyle Reservoir Bed Sediments"), value = TRUE),
              checkboxInput("show_ig_reservoir_bedsed", HTML("<span style='color:lavender;'>&#9673;</span> Iron Gate Reservoir Bed Sediment Cores"), value = TRUE),
              checkboxInput("show_geomorphic_reaches", HTML("<span style='color:brown;'>&#9673;</span> Geomorphic Reaches"), value = TRUE),
              checkboxInput("show_sediment_bug", HTML("<span style='color:yellow;'>&#9673;</span> Sediment Bug Samples"), value = TRUE),
              checkboxInput("show_fingerprinting", HTML("<span style='color:lightgreen;'>&#9673;</span> Tributary Fingerprinting Samples"), value = TRUE)
              )
            ),
          p(class = "legend-description", "These layers were sourced from",
            tags$a(href = 'https://ca.water.usgs.gov/apps/klamath-dam-removal-monitoring.html', 
                   "USGS Dam Removal Monitoring Map", target = "_blank"))
          ),
        
        mainPanel(width = 9,
          leafletOutput("mainMap", height = "1000px")
          )
        )
      ),
    
    # DATA EXPLORER PANEL
    tabPanel(
      "Data Explorer",
      sidebarLayout(
        sidebarPanel(
        h5("This tab displays summarized tabular data categorized by data type. Additional filtering options (e.g., watershed, agency, etc.) will be available. The 'Go to Map' button will direct users to the location on the map where the selected data row was collected.
              This section is still in progress and will undergo multiple iterations."),
        br(),
        selectInput("data_type", "Select Data Type:",
                    choices = c("Select Data Type", "All", "Flow", "Temperature", "Dissolved Oxygen", "pH", "Habitat Models", "Hatcheries", 
                                "Rotary Screw Traps", "Fish Habitat Extents", "Redd/Carcass Surveys")),
        selectInput("sub_basin", "Select Sub-Basin:",
                    choices = c("All", "Williamson", "Sprague", "Upper Klamath Lake", "Butte", "Shasta", "Scott", 
                                "Lower Klamath", "Salmon", "Trinity", "South Fork Trinity", "Lost"))
        # hr()
        ),
        mainPanel(
          # div(style = "height: 800px; width: 100%; overflow-x: auto;",
          DTOutput("data_table")
          )
        )
      )
    )
  )

