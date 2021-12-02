library(shiny)
library(ggplot2)
library(tidyverse)
library(shiny)
library(shinyauthr)


files <- c("welcome.R","load.R","utils.R", "dataset.R", "reports.R","global.R")
map(files, source)

##utils or random parts
dfs <- readRDS("df.rds")
#df <- readRDS("R/df.rds")
#nrow(df)
upload_df <- tibble()



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




