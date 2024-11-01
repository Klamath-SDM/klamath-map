shinyServer(function(input, output, session) {
  
  source("modules/monitoring_module.R")
  source("modules/reference_module.R")
  
  monitoring_tab_server("monitoring")
  
  insertUI(
    selector = ".navbar .container-fluid .navbar-collapse",
    ui = tags$ul(class = "nav navbar-nav navbar-right",
                 tags$li(
                   div(style = "padding: 10px; padding-top: 8px; padding-bottom: 0;",
                       shinyauthr::logoutUI("logout"))
                 ))
  )
  
  

})
