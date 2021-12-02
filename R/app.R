library(shiny)
library(ggplot2)
library(tidyverse)
library(shiny)
library(shinyauthr)


files <- c("welcome.R","load.R","utils.R", "dataset.R", "reports.R")
map(files, source)




ui <- fluidPage(
  tabsetPanel(
  ## Welcome post
  welcomeUI("welcome"),
  datasetUI("dataset"),
  reportsUI("report"),
  loadUI("load")
  ))

server <- function(input, output, session) {
  loadServer("load")
}

reactlog::reactlog_enable()
shinyApp(ui, server)



