library(shiny)
library(ggplot2)
library(tidyverse)
library(shiny)
library(shinyauthr)

## password database
user_base <- tibble(
  user = c("user1", "user2"),
  password = sapply(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)

## define dataset
## should load the saved dataset right away
ui <- fluidPage(
  # password adjustments
    # logout button
    div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
    
    # login section
    shinyauthr::loginUI(id = "login"),
    
    # Sidebar to show user info after login
    uiOutput("sidebarpanel"),
    
    # Plot to show user info after login
    plotOutput("distPlot")
    

  
  
  tabsetPanel(
  ## Welcome post
    tabPanel("Welcome"),
  ## show the dataset
    tabPanel("Dataset"),
  ## select date range of data input
    tabPanel("Reports"),
  ## select variable
  
  ## show summary on select variable
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
      )
    )
  

server <- function(input, output, session) {
  ups <- tibble()
  
  ## takes upload data input and reads the dataset
  up <- reactive({
    req(input$upload)
    ext <- tools::file_ext(input$upload$name)
    xlsx <-  readxl::read_excel(input$upload$datapath)%>% select(1:11) 
    ups <- xlsx
    xlsx
      }
      )
  
  ## check variable names
  up_name_check <- reactive({
    ncheck <- c(
    "pid"  ,                                                
    "ui:2" ,                                                
    "proc:2",                                              
    "med:2",                                                
    "ui_any:2" ,                                            
    "age_bin_5:14" ,                                        
    "charlson_comorb:5 (1-5, 1 being mild 5 being extreme)",
    "zip3:20 (not accurately distributed)",                 
    "date_dx_proc_med:91" ,                                 
    "referal:3" ,                                           
    "PRO_1:4"   
    )
    names <- up() %>% names() 
    checked <- (names == ncheck) 
    df <- tibble(names,checked)
    df
  })
  

  # print up_name_check
  output$up_name_check <- renderPrint({
    up_name_check()
  })
  
  ## print confirmation text
  output$up_conf <- renderText({
    df <- up_name_check()
    if(all(df$checked)){
      "Variables Match"
      # call function save
    } else 
      "Variables Do Not Match"
      # dont call function save
  })

  ## output head from upload dataset 
  output$head <- renderTable({
    head(up(), input$upload_n)
  })
  
  output$up_save <-
    renderUI(expr = if (all(up_name_check()$checked)) {
      submitButton()
    } else {
      NULL
    })
  
  observeEvent(input$up_save,  {
    df <- rbind(df,up)
    saveRDS(ups, file="df.rds")
   })
}

shinyApp(ui, server)
