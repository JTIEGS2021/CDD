## password database
user_base <- tibble(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)




loadUI <- function(id) {
  
  tabPanel("load",
         # input uploadload data
         fileInput(NS(id,"upload"), NULL, accept = c(".xlsx")),
         ## input n rows
         numericInput(NS(id,"upload_n"), "Check Rows", value = 5, min = 1, step = 1),
         ## output head
         tableOutput(NS(id,"head")),
         ## name check
         verbatimTextOutput(NS(id,"upload_name_check")),
         ## confirmation box
         textOutput(NS(id,"upload_conf")),
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
      uploads <- tibble()
      flag <- reactiveVal(F)
      
      ## takes upload data input and reads the dataset
      upload <- reactive({
        req(input$upload)
        ext <- tools::file_ext(input$upload$name)
        xlsx <-  readxl::read_excel(input$upload$datapath)%>% select(1:11) 
        upload_df <<- xlsx
        return(xlsx)
      }
      )
      
      ## check variable names
      upload_name_check <- reactive({
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
        names <- upload() %>% names()  
        checked <- (names == ncheck) 
        if(all(checked)){
          flag(T)
        } 
        df <- tibble(names,checked)
        return(df)
      })
      
      
      ## print upload_name_check
      output$upload_name_check <- renderPrint({
        upload_name_check()
      })
      
      ## print confirmation text
      output$upload_conf <- renderText({
        df <- upload_name_check()
          if(flag()){
          "Variables Match"
        } else 
          "Variables Do Not Match"
        # dont call function save
      })
      
      ## output head from upload dataset 
      output$head <- renderTable({
        head(upload(), input$upload_n)
      })
      
      observeEvent(flag(),{
        if(flag() == TRUE) {
          insertUI("#load-upload_conf", "afterEnd",
                   actionButton(NS(id,"upload_save"), "Action"))
        }
        })
      
      observeEvent(input$upload_save, {
                   print("Yes")
                   df <-rbind(df, upload_df)
                   saveRDS(df, file="df.rds")
                   removeUI("#load-upload_save")}
                   )
      # render the save button if all upload_name_check()$checked are true
      # output$upload_save <-
      #   renderUI(expr = if (all(upload_name_check()$checked)) {
      #     submitButton("submit")
      #   } else {
      #     NULL
      #   })
      
      
      
      # eventReactive(input$submit, {
      #   df <- rbind(df,upload_df)
      #   saveRDS(df, file="df.rds")
      #  }
      #  )
    }
  )
}





