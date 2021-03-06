################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                            Time on Site Analysis                           ##
##                                                                            ##            
##                    App & Code by Maximilian H. Nierhoff                    ##
##                                                                            ##
##                           http://nierhoff.info                             ##
##                                                                            ##
##   Live version of this app: http://apps.nierhoff.info/bplusd-interactive   ##
##                                                                            ##
##                                 Github Repo:                               ##
##   https://github.com/mhnierhoff/shiny-apps/tree/master/bplusd-interactive  ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

suppressPackageStartupMessages(c(
        library(shiny),
        library(shinyIncubator),
        library(shinythemes),
        library(lubridate),
        library(zoo),
        library(timeDate),
        library(forecast),
        library(knitr),
        library(reshape),
        library(DT),
        library(RColorBrewer),
        library(googleVis),
        library(BreakoutDetection),
        library(rmarkdown)))

shinyUI(navbarPage("Time on Site Analysis", 
                   
                   theme = shinytheme("flatly"),
                   
                   
                   
############################### ~~~~~~~~1~~~~~~~~ ##############################                   

## NAVTAB 1 - EDA
tabPanel("Overview",
         
         tags$head(includeScript("./js/ga-bplusd-interactive.js")),
         
         sidebarLayout(
                 
                 sidebarPanel(
                         
                         tags$h4("Exploratory Data Analysis"),
                         tags$br(),
                         radioButtons(inputId = "tabOne",
                                      label = "Select a website:",
                                      choices = c("Sony", 
                                                  "Postbank", 
                                                  "Maxdome", 
                                                  "Vorwerk", 
                                                  "Germanwings"),
                                      selected = "Sony"),
                         
                         width = 3),
                 
                 mainPanel(
                         
                         tabsetPanel(
                                 tabPanel("Line Chart", 
                                          plotOutput("linePlot"),
                                          tags$hr(),
                                          plotOutput("clinePlot")),
                                 
                                 tabPanel("Boxplot",
                                          plotOutput("boxPlot"),
                                          tags$div(textOutput("boxPlotCaption"), 
                                                 align = "center"),
                                          tags$hr(),
                                          plotOutput("cboxPlot")),
                                 
                                 tabPanel("Histogram",
                                          plotOutput("histPlot"),
                                          tags$div(textOutput("histPlotCaption"), 
                                                   align = "center")),
                                 
                                 tabPanel("Summary",
                                          tags$br(),
                                          textOutput("summaryCaption1"),
                                          tags$small("(All values are in seconds.)"),
                                          tags$br(),
                                          tags$br(),
                                          textOutput("summaryCaption2"),
                                          textOutput("summaryCaption3"),
                                          textOutput("summaryCaption4"),
                                          textOutput("summaryCaption5"),
                                          textOutput("summaryCaption6"),
                                          textOutput("summaryCaption7"),
                                          textOutput("summaryCaption8"),
                                          textOutput("summaryCaption9"),
                                          textOutput("summaryCaption10"),
                                          textOutput("summaryCaption11"),
                                          textOutput("summaryCaption12"),
                                          textOutput("summaryCaption13")),
                                 
                                 tabPanel("Raw Data",
                                          tags$br(),
                                          dataTableOutput("dataTable"))
                                               
                         ),
                         width = 6)
         )
),
                   
############################### ~~~~~~~~2~~~~~~~~ ##############################

## NAVTAB 2 - Forecasting

tabPanel("Forecasting",
         
         sidebarLayout(
                 
                 sidebarPanel(
                         radioButtons(inputId = "tabTwo",
                                     label = "Select a website:",
                                     choices = c("Sony", 
                                                 "Postbank", 
                                                 "Maxdome", 
                                                 "Vorwerk", 
                                                 "Germanwings"),
                                     selected = "Sony"),
                         
                         tags$hr(),
                         
                         selectInput(inputId = "model",
                                     label = "Select a Forecasting model:",
                                     choices = c("ARIMA", "ETS", "TBATS", 
                                                 "StructTS", "Holt-Winters", 
                                                 "Theta", "Cubic Spline",
                                                 "Random Walk", "Naive",
                                                 "Mean"),
                                     selected = "ARIMA"),
                         
                         tags$hr(),
                         
                         numericInput("ahead", "Days to forecast ahead:", 30),
                         
                         width = 3),
                 
                 mainPanel(
                         
                         plotOutput("forecastPlot"),
                         tags$strong(textOutput("forecastCaption"), 
                                     align = "center"),
                         
                         width = 6)
                 
         )
),
                   
                   
############################### ~~~~~~~~3~~~~~~~~ ##############################                   

## NAVTAB 3 - Breakout Detection

tabPanel("Breakout Detection",
         
         sidebarLayout(
                 
                 sidebarPanel(
                         radioButtons(inputId = "tabThree",
                                      label = "Select a website:",
                                      choices = c("Sony", 
                                                  "Postbank", 
                                                  "Maxdome", 
                                                  "Vorwerk", 
                                                  "Germanwings"),
                                      selected = "Sony"),
                         
                         width = 3),
                 
                 mainPanel(
                         
                         plotOutput("adPlot"),
                         tags$div(textOutput("breakoutCaptionT"), 
                                     align = "center"),
                         tags$div(textOutput("breakoutCaptionV"), 
                                     align = "center"),
                         
                         width = 6)
         )
),
                   
############################### ~~~~~~~~4~~~~~~~~ ##############################
                   
## NAVTAB 4 - Decomposition

tabPanel("Decomposition",
         
         sidebarLayout(
                 
                 sidebarPanel(
                         radioButtons(inputId = "tabFour",
                                      label = "Select a website:",
                                      choices = c("Sony", 
                                                  "Postbank", 
                                                  "Maxdome", 
                                                  "Vorwerk", 
                                                  "Germanwings"),
                                      selected = "Sony"),
                         
                         width = 3),
                 
                 mainPanel(
                         
                         
                         tabsetPanel(
                                 
                                 tabPanel("Normal Timeseries Decomposition",
                                          tags$br(),
                                          plotOutput("Ndcomp"),
                                          tags$div(textOutput("NTScaption"),
                                                   align = "center")),
                                 
                                 tabPanel("STL Decomposition",
                                          tags$br(),
                                          tags$div(strong("STL Decomposition"), 
                                                   align ="center"),
                                          plotOutput("STLdcomp"),
                                          tags$div(textOutput("STLcaption"),
                                                   align = "center"))
                                 
                         ),
                         
                         width = 6)
                 
         )
         
),          

############################### ~~~~~~~~5~~~~~~~~ ##############################

## NAVTAB 5 - Calendar View

tabPanel("Calendar View",
         
         sidebarLayout(
                 
                 sidebarPanel(
                         radioButtons(inputId = "tabFive",
                                      label = "Select a website:",
                                      choices = c("Sony", 
                                                  "Postbank", 
                                                  "Maxdome", 
                                                  "Vorwerk", 
                                                  "Germanwings"),
                                      selected = "Sony"),
                         
                         width = 3),
                 
                 mainPanel(
                         
                         htmlOutput("calendarPlot"),
                         
                         width = 6)
                 
         )
         
),

############################### ~~~~~~~~A~~~~~~~~ ##############################
                   
## About

tabPanel("About",
         fluidRow(
                 column(1,
                        p("")),
                 column(10,
                        includeMarkdown("./about/about.md")),
                 column(1,
                        p(""))
         )
),

############################### ~~~~~~~~F~~~~~~~~ ##############################
                   
## Footer
                   
tags$hr(),

tags$span(style="color:darkslategrey", 
          tags$div(textOutput("dataPeriodCaption"), 
                        align = "center")
         ),

tags$span(style="color:darkslategrey", 
          tags$div("Data source: Alexa.com | Metric: Alexa Time on Site", 
                   align="center")
        ),

tags$br(),

tags$span(style="color:grey", 
          tags$footer(("© 2015 - "), 
                      tags$a(
                              href="http://nierhoff.info",
                              target="_blank",
                              "Maximilian H. Nierhoff."), 
                      tags$br(),
                      ("Built with"), tags$a(
                              href="http://www.r-project.org/",
                              target="_blank",
                              "R,"),
                      tags$a(
                              href="http://shiny.rstudio.com",
                              target="_blank",
                              "Shiny"),
                      ("&"), tags$a(
                              href="http://www.rstudio.com/products/shiny/shiny-server",
                              target="_blank",
                              "Shiny Server."),
                      ("Hosting on"), tags$a(
                              href="https://www.digitalocean.com/?refcode=f34ade566630",
                              target="_blank",
                              "DigitalOcean."),
                      
                      align = "center"),
          
          tags$br()
          
)
)
)