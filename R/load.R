## UI Functions ************************
## loadUI 
## - used by load_pass upon accepted password
loadUI <- function(id) {
  insertUI(
    "#load-status",
    "afterEnd",
    tagList(
      fileInput(NS(id, "upload"), NULL, accept = c(".xlsx")),
      numericInput(
        NS(id, "upload_n"),
        "Check Rows",
        value = 5,
        min = 1,
        step = 1
      ),
      textInput(NS(id, "subID"), "Submission ID (as date if not replaced)",value = str_replace_all(Sys.Date(),"-","")),
      textOutput(NS(id, "subdate")),
      tableOutput(NS(id, "head")),
      verbatimTextOutput(NS(id, "upload_name_check")),
      textOutput(NS(id, "upload_conf")),
      
      #actionButton(NS(id,"test"),"test")
    )
  )
}

## Load loadsumUI components
loadsumUI <- function(id) {
  message("loadUI")
  insertUI(
    "#load-upload_conf",
    "afterEnd",
    tagList(
      actionButton(NS(id, "upload_save"), "Submit"),
      textOutput(NS(id, "subconf")),
      textOutput(NS(id, "subsum"))

      #gt::gt_output(NS(id, "subsum"))
    )
  )
}

# Remove loadsumUI components
loadsumUI_drop <- function(id){
  message("removeUI")
  removeUI("#load-upload_save")
  removeUI("#load-subsum")
  removeUI("#load-subconf")
}

## Server  *****************************
loadServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {

                 check_flag <- reactiveVal(NULL)
                  
                 ## Direct Outputs
                 output$subdate = renderPrint(print(Sys.Date()))
                 output$upload_conf <- renderText({"Please Load A Dataset"})
                 output$head <- renderTable({
                   head(upload(), input$upload_n)
                 })
                 
                 ## - output reactive to check_flag state
                 output$upload_conf <- renderText({
                   if (is.null(check_flag())) {
                     "Please Load A Dataset"
                   } else if (check_flag() == T) {
                     "Variables Match"
                   } else if (check_flag() == F) {
                     "Variables Do Not Match"
                   }
                 })
                 
                 
                 ## Reactively collects xlsx selected
                 ## - add try-catch
                 upload <- reactive({
                   req(input$upload)
                   upload_df <-
                     readxl::read_excel(input$upload$datapath) %>%
                     select(1:11)
                   upload_df
                 })
                 
                 ## Drops sumUI components when new xlsx is selected
                 ## - specifically used for multiple selection of xlsx
                 observeEvent(upload(), {
                   loadsumUI_drop(id)
                 })
                 
                
                 ## - Check variable names
                 ## - Outputs confirmation of variable name check
                 observeEvent(upload(), {
                   check_flag(NULL)
                   names <- upload() %>% names()
                   checked <- (names == ncheck)
                   if (all(checked)) {
                     check_flag(T)
                   } else {
                     check_flag(F)
                   }
                   output$upload_name_check <-
                     renderPrint({
                       tibble(names, checked)
                     })
                 })
                 
                 ## Load sumUI components
                 ## - requires check_flag() to be True
                 observeEvent(check_flag(), {
                   message("checkflag true")
                   if(check_flag() == T){
                     loadsumUI(id)
                   }
                 })
                 
                 ## - Reacts to selecting submit button 
                 ## - Concats, upload() to df, 
                 ## - Adds ID and date to upload()  
                 ## - Removes submit button to prevent double submission
                 observeEvent(input$upload_save, {
                   message("uploading")
                    df_base <<- rbind(df_base, upload()%>% 
                                        mutate(id = input$subID, date = Sys.Date()))
                    saveRDS(df_base, file = "df_base.rds")
                   output$subconf <-renderText("Data saved to main DF")
                   output$subsum <- renderText(nrow(df_base))
                   removeUI("#load-upload_save")
                   check_flag(NULL)
                 })
               })
  
  
}





