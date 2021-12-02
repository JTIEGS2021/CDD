## password database
user_base <- tibble(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)




loadUI <- function(id) {
  # Static Component
  # - load table field
  # - number of rows to display field
  # - table display 
  # - review of upload varriable matching
  # - verbale confirmation field
  
  # Dynamic
  # - submit button
  # - confirmation of submission
  
  tabPanel("load",
    fileInput(NS(id, "upload"), NULL, accept = c(".xlsx")),
    numericInput(NS(id, "upload_n"), "Check Rows", value = 5, min = 1, step = 1),
    tableOutput(NS(id, "head")),
    verbatimTextOutput(NS(id, "upload_name_check")),
    textOutput(NS(id, "upload_conf"))
  )
}

loadServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 # reactive flags
                 upload_flag <- reactiveVal(NULL)
                 
                 ## takes upload data input and reads the dataset
                 ## sets upload_df globally
                 upload <- reactive({
                   req(input$upload)
                   ext <- tools::file_ext(input$upload$name)
                   xlsx <-
                     readxl::read_excel(input$upload$datapath) %>% select(1:11)
                   upload_df <- xlsx 
                   return(xlsx)
                 })
                 
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
                   if (all(checked)) {
                     upload_flag(T)
                   } else upload_flag(F)
                   return(tibble(names, checked))
                 })
                 
                 
                 ## print upload_name_check
                 output$upload_name_check <- renderPrint({
                   upload_name_check()
                 })
                 
                 ## print confirmation text
                 output$upload_conf <- renderText({"Please Load A Dataset"})
                 observeEvent(upload_flag(), {
                   output$upload_conf <- renderText({
                     if (upload_flag()) {
                       "Variables Match"
                     } else if (upload_flag() == F) {
                       "Variables Do Not Match"
                     }
                   })
                 })
                   
                 
                  
                 ## output head from upload dataset
                 output$head <- renderTable({
                   head(upload(), input$upload_n)
                 })
                 
                 ## Once the upload content is verified, submit button is displayed
                 observeEvent(upload_flag(), {
                   if (upload_flag() == TRUE) {
                     insertUI("#load-upload_conf",
                              "afterEnd",
                              actionButton(NS(id, "upload_save"), "Submit"))
                   }
                 })
                 
                 ## Reacts to selecting submit, adds upload to df, then removes submit 
                 observeEvent(input$upload_save, {
                   print("Yes")
                   df <- rbind(dfs, upload_df)
                   saveRDS(df, file = "df.rds")
                   removeUI("#load-upload_save")
                 })
               })
}





