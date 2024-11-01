reference_tab_ui <- function(id){
  ns <- NS(id)
  tabPanel("Reference",
           fluidRow(
             tags$div(class="reference-content",
                      HTML("<p><strong>External resources</strong></p>"),
                      tags$ul(tags$li(HTML("<a href=https://water.ca.gov/Programs/State-Water-Project/Endangered-Species-Protection target=_blank>DWR State Water Project Incidental Take Permit landing page</a>"))))

           )
           #HTML("<iframe class=reference-doc src=https://docs.google.com/document/d/1as6af_NwmaNZ9H9zN9MT9A11w8svoGmNQbye5a7k6KY/preview>"),
           )
}
