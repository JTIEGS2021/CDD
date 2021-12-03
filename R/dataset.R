# Dataset Tab

## UI modules ****************
## Components for the df_base display
datasetUI <- function(id) {
  tabPanel("Dataset",
           h2("Dataset Summary"),
           dataTableOutput(NS(id, "base_table")),
           actionButton(NS(id, "refresh"), "refresh"))
           }

## Server ********************
datasetServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 df_base_r <- reactiveVal(df_base)
                 
                 ## Sets the dataframe output with the df_base_r variable
                 output$base_table <- renderDataTable(
                   df_base_r(),
                   options = list(pageLength = 10)
                   )
                 
                 ## Updates the df_base_r variable 
                 ## - rereads from disk when refresh button selected
                 observeEvent(input$refresh, {
                   df_base_r(read_df_base())
                 })
                 
               })
}