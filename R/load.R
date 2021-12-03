## Functions ************************
# add the load UI 
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
      textInput(NS(id, "subID"), "Submission ID (as date if not replaced)",value = str_replace_all(sub_date,"-","")),
      tableOutput(NS(id, "head")),
      verbatimTextOutput(NS(id, "upload_name_check")),
      textOutput(NS(id, "upload_conf")),
    )
  )
}

# loaded summary report
loadsumUI <- function(id) {
  insertUI(
    "#load-upload_conf",
    "afterEnd",
    tagList(
      actionButton(NS(id, "upload_save"), "Submit"),
      textOutput(NS(id, "subdate")),
      textOutput(NS(id, "subconf")),
      textOutput(NS(id, "subsum"))

      #gt::gt_output(NS(id, "subsum"))
    )
  )
}

# remove loadsumUI components
loadsumUI_drop <- function(id){
  removeUI("#load-subsum")
  removeUI("#load-subconf")
}





## Modules *****************************
loadServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 # reactive variables
                 loadflag <- reactiveVal(F)
                 check_flag <- reactiveVal(NULL)
                 
                 ## Reactives **************
                 ## Initial State
                 #add date
                 output$subdate = renderPrint(print(sub_date))
                 output$upload_conf <- renderText({"Please Load A Dataset"})
                 
                 ## takes upload data input and reads the dataset
                 ## sets upload_df globally
                
                 
                 upload <- reactive({
                   req(input$upload)
                   upload_df <-
                     readxl::read_excel(input$upload$datapath) %>%
                     select(1:11)%>% 
                     mutate(id = input$subID, date = Sys.Date())
                   loadflag(T)
                   loadsumUI_drop(id)
                   upload_df
                 })
                 

                 output$head <- renderTable({
                   head(upload(), input$upload_n)
                 })
                 
                 ## check variable names
                 observeEvent(upload(), {
                   removeUI("#load-upload_save")
                   if (loadflag() == T) {
                     names <- upload() %>% names()
                     checked <- (names == ncheck)
                     if (all(checked)) {
                       check_flag(T)
                       loadsumUI(id)
                     } else {
                       check_flag(F)
                     }
                     output$upload_name_check <- renderPrint({tibble(names,checked)})
                   }
                 })
                 

                
                 output$upload_conf <- renderText({
                   if (is.null(check_flag())) {
                     "Please Load A Dataset"
                   } else if (check_flag() == T) {
                     "Variables Match"
                   } else if (check_flag() == F) {
                     "Variables Do Not Match"
                   }
                 })

                 
                 ## Reacts to selecting submit, adds upload to df, then removes submit 
                 observeEvent(input$upload_save, {
                   message("worrking")
                   df_base <<- rbind(df_base, upload())
                   saveRDS(df_base, file = "df_base.rds")
                   removeUI("#load-upload_save")
                   output$subconf <-renderText("Data saved to main DF")
                   output$subsum <- renderText(nrow(df_base))
                   check_flag(NULL)
                 })
               })
}





