## password database
user_base <- tibble(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)


loadUI <- function(id) {
  
  tabPanel("load",
         # input upload data
         fileInput(NS(id,"upload"), NULL, accept = c(".xlsx")),
         ## input n rows
         numericInput(NS(id,"upload_n"), "Check Rows", value = 5, min = 1, step = 1),
         ## output head
         tableOutput(NS(id,"head")),
         ## name check
         verbatimTextOutput(NS(id,"up_name_check")),
         ## confirmation box
         textOutput(NS(id,"up_conf")),
         ## save to full dataset
         # actionButton(NS(id,"up_save"), 'save')
         # #uiOutput(NS(id,"up_save"))
         
         textOutput(NS(id,"test"))
  )
}

loadServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ups <- tibble()
      flag <- reactiveVal(F)
      
      ## takes upload data input and reads the dataset
      up <- reactive({
        req(input$upload)
        ext <- tools::file_ext(input$upload$name)
        xlsx <-  readxl::read_excel(input$upload$datapath)%>% select(1:11) 
        return(xlsx)
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
        if(all(checked)){
          flag(T)
        } 
        df <- tibble(names,checked)
        return(df)
      })
      
      
      # print up_name_check
      output$up_name_check <- renderPrint({
        up_name_check()
      })
      
      ## print confirmation text
      output$up_conf <- renderText({
        df <- up_name_check()
        #if(all(df$checked)){
          if(flag()){
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
      
      observeEvent(flag(),{
        if(flag() == TRUE) {
          insertUI("#load-up_conf", "afterEnd",
                   actionButton(NS(id,"up_save"), "Action"))
        }
        })
      
      observeEvent(input$up_save, {
                   print("Yes")
                   df <- rbind(df,up)
                   saveRDS(up, file="df.rds")}
                   )
      # render the save button if all up_name_check()$checked are true
      # output$up_save <-
      #   renderUI(expr = if (all(up_name_check()$checked)) {
      #     submitButton("submit")
      #   } else {
      #     NULL
      #   })
      
      
      
      eventReactive(input$submit, {
        df <- rbind(df,up)
        saveRDS(up, file="df.rds")
        }
      )
    }
  )
}





