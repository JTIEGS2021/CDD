library(shiny)
library(ggplot2)
library(tidyverse)
library(shiny)
library(shinyauthr)
library(gtsummary)
library(gt)
library(glue)

files <- c("welcome.R","load.R","utils.R", "dataset.R", "reports.R","global.R",
           "load_pass.R")
map(files, source)


ui <- fluidPage(
  tabsetPanel(id="tabs",
  ## Welcome post
  welcomeUI("welcome"),
  datasetUI("dataset"),
  reportsUI("report"),
  passUI("load"),
  #loadUI("load")
  ))

server <- function(input, output, session) {
  
  passServer("load")
  loadServer("load")
  datasetServer("dataset")
  reportServer("report")
}

reactlog::reactlog_enable()
shinyApp(ui, server)

 



