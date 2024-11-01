library(shiny)
library(leaflet)

ui <- navbarPage(
  title = "Klamath SDM Map",
  id = "tabs", # must give id here to add/remove tabs in server
  collapsible = TRUE,
  login_tab
)



