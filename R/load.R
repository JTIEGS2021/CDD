## password database
user_base <- tibble(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)


loadUI <- function(id) {
  ns <- NS(id)
  
  tabPanel("Load Data",
         ## input upload data
         fileInput("upload", NULL, accept = c(".xlsx")),
         
         ## input n rows
         numericInput("upload_n", "Check Rows", value = 5, min = 1, step = 1),
         
         ## output head
         tableOutput("head"),
         
         ## name check
         verbatimTextOutput("up_name_check"),
         
         ## confirmation box
         textOutput("up_conf"),
         
         ## save to full dataset
         uiOutput('up_save')
  )
}








# 
# linkedScatter <- function(input, output, session, data, left, right) {
#   # Yields the data frame with an additional column "selected_"
#   # that indicates whether that observation is brushed
#   dataWithSelection <- reactive({
#     brushedPoints(data(), input$brush, allRows = TRUE)
#   })
#   
#   output$plot1 <- renderPlot({
#     scatterPlot(dataWithSelection(), left())
#   })
#   
#   output$plot2 <- renderPlot({
#     scatterPlot(dataWithSelection(), right())
#   })
#   
#   return(dataWithSelection)
# }