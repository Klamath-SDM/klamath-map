library(shiny)
library(shinyjs)
library(leaflet)
library(DT)

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body { 
        font-family: Helvetica, Arial, sans-serif; 
        background: linear-gradient(to bottom, #F0F8FF, #004d99);
        background-attachment: fixed; 
        margin: 0;
        padding: 0;
      }

      .title-panel {
        font-size: 30px;
        font-weight: bold;
        color: white;
        text-align: center;
        padding: 70px;
        border-radius: 8px;
        box-shadow: 5px 5px 10px rgba(0,0,0,0.2);
        background-image: url('klamath_image_1.jpg');
        background-size: cover;
        background-position: center;
      }

      .card-box {
        background-color: white;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.15);
      }

      .card-title {
        font-weight: bold;
        font-size: 18px;
        margin-bottom: 10px;
        color: #004d99;
      }

      .nav-card {
        background-color: white;
        text-align: left;
        cursor: pointer;
        border: none;
        width: 100%;
      }

      .nav-card:hover {
        box-shadow: 0 0 12px rgba(0,0,0,0.2);
      }

      .legend-item {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .legend-description {
        font-style: italic;
      }
      
      .nav-card p {
      white-space: normal !important;
      word-wrap: break-word;
      overflow-wrap: break-word;
    }

    .card-box {
      height: 100%; 
    }
    "))
  ),
  
  div(class = "title-panel", "Klamath Basin Data Viewer"),

  # Navigation cards
  div(id = "home_panel", style = "margin-top: 30px;",
      fluidRow(
        column(6,
               actionButton("show_map", 
                            label = tagList(
                              div(class = "card-title", "🗺️ Monitoring Site Map"),
                              p("View the interactive map and filter monitoring locations.
                                There is a wealth of data about water and ecological resources in the Klamath Basin collected over multiple decades by many entities. 
                                The high volume and dispersed nature of these data make it challenging to quickly determine data availability. 
                                This map was developed to support the Klamath Basin Science Collaborative by summarizing the data being collected in the Basin.")
                            ),
                            class = "card-box nav-card"
               )
        ),
        column(6,
               actionButton("show_explorer", 
                            label = tagList(
                              div(class = "card-title", "📊 Data Explorer"),
                              p("Explore and download tabular data from the Klamath Basin.")
                            ),
                            class = "card-box nav-card"
               )
        )
      )
  ),
  
  # MAP PANEL
  div(id = "map_panel", style = "display:none;",
      actionButton("go_home_from_map", "⬅ Back to Home", class = "btn btn-primary"), 
      fluidRow(
        column(12,
               div(class = "card-box",
                   sidebarLayout(
                     sidebarPanel(
                       # h5("There is a wealth of data about water and ecological resources in the Klamath Basin collected over multiple decades by many entities. The high volume and dispersed nature of these data make it challenging to quickly determine data availability. This map was developed to support the Klamath Basin Science Collaborative by summarizing the data being collected in the Basin."),
                       br(),
                
                # Select Input for Zooming to Rivers
                selectInput(
                  "zoom_select_river", 
                  "Zoom to Basin",
                  c(
                    "(Default View)", sort(c(
                      "Williamson",
                      "Sprague",
                      "Upper Klamath Lake",
                      "Butte",
                      "Shasta",
                      "Scott",
                      "Lower Klamath",
                      "Salmon",
                      "Trinity",
                      "South Fork Trinity",
                      "Lost"
                    )
                    ))),
                
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
                    checkboxInput("show_do_gages", HTML("<span><i class='fa fa-tint' style='color: blue; font-size: 16px;'></i> DO gage</span>"), value = TRUE),
                    checkboxInput("show_ph_gages", HTML("<span><i class='fa fa-tint' style='color: green; font-size: 16px;'></i> pH gage</span>"), value = TRUE)
                  )
                ),
                
                p(class = "legend-description", "Legend here"),
                
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
                
                # Species Abundance Map Layers ---
                tags$div(
                  class = "legend-item",
                  checkboxInput("show_fish_abundance", "Fish Abundance", value = TRUE)
                  ),
                conditionalPanel(
                  condition = "input.show_fish_abundance == true",
                  tags$div(
                    style = "margin-left: 20px;",
                    checkboxInput("show_chinook_abundance", HTML("<span><img src='legend-abundance-1.png' style='width: 20px; height: 20px;'/> Chinook Salmon Abundance</span>"), value = TRUE),
                    checkboxInput("show_coho_abundance", HTML("<span><img src='legend-abundance-2.png' style='width: 20px; height: 20px;'/> Coho Abundance</span>"), value = TRUE),
                    checkboxInput("show_steelhead_abundance", HTML("<span><img src='legend-abundance-3.png' style='width: 20px; height: 20px;'/> Steelhead Abundance</span>"), value = TRUE)
                    )
                  ),
                
                p(class = "legend-description", "These layers were sourced from",
                  tags$a(href = 'https://gis.data.ca.gov/', 
                         "California State Geoportal", target = "_blank"))
                     ),
                
                hr(),
                
                
                
                # USGS Dam Removal Map Layers
                tags$div(
                  class = "legend-item",
                  checkboxInput("show_usgs_dam_layers", "USGS Dam Removal Monitoring Map Layers", value = TRUE)
                ),
                conditionalPanel(
                  condition = "input.show_usgs_dam_layers == true",
                    checkboxInput("show_dams_tb_removed", HTML("<span style='color:red;'>&#9673;</span> Removed Dams"), value = TRUE),
                    checkboxInput("show_dams", HTML("<span style='color:blue;'>&#9673;</span> Existing Dams"), value = TRUE),
                    checkboxInput("show_copco_res", HTML("<span style='color:orange;'>&#9673;</span> Copco Reservoir Bed Sediment Cores"), value = TRUE),
                    checkboxInput("show_estuary_bedsed", HTML("<span style='color:purple;'>&#9673;</span> Estuary Bed Sediment Samples"), value = TRUE),
                    checkboxInput("show_jc_boyle_reservoir_bedsed", HTML("<span style='color:cyan;'>&#9673;</span> JCBoyle Reservoir Bed Sediments"), value = TRUE),
                    checkboxInput("show_ig_reservoir_bedsed", HTML("<span style='color:lavender;'>&#9673;</span> Iron Gate Reservoir Bed Sediment Cores"), value = TRUE),
                    checkboxInput("show_geomorphic_reaches", HTML("<span style='color:brown;'>&#9673;</span> Geomorphic Reaches"), value = TRUE),
                    checkboxInput("show_sediment_bug", HTML("<span style='color:yellow;'>&#9673;</span> Sediment Bug Samples"), value = TRUE),
                    checkboxInput("show_fingerprinting", HTML("<span style='color:lightgreen;'>&#9673;</span> Tributary Fingerprinting Samples"), value = TRUE)
                ),
                p(class = "legend-description", "These layers were sourced from",
                  tags$a(href = 'https://ca.water.usgs.gov/apps/klamath-dam-removal-monitoring.html', 
                         "USGS Dam Removal Monitoring Map", target = "_blank"))
              ),
            mainPanel(
              leafletOutput("mainMap", height = "1000px")
            )
          )
        )
      )
    )
  ),

  # DATA EXPLORER PANEL
  div(id = "explorer_panel", style = "display:none;",
      actionButton("go_home_from_explorer", "⬅ Back to Home", class = "btn btn-primary"),
      
    fluidRow(
      column(12,
        div(class = "card-box",
          sidebarLayout(
            sidebarPanel(
              h5("This tab displays summarized tabular data categorized by data type."),
              br(),
              selectInput("data_type", "Select Data Type:",
                choices = c("Select Data Type", "Flow Data", "Temperature Data", "Habitat Data", "RST Data")),
              selectInput("watershed", "Select Watershed: (pending)", choices = c("All"))
            ),
            mainPanel(
              DTOutput("data_table")
            )
          )
        )
      )
    )
  )
)

