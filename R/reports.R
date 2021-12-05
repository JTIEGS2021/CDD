# Reports Page
reportsUI <- function(id) {
  tabPanel("Reports",
           h2("Select Variables"),
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 NS(id, "add"),
                 "Select Variables",
                 choices = c("All", global_add),
                 multiple = TRUE
               ),
               
               h3("Select Id or Dates"),
               selectInput(NS(id,"id"),"Select ID (default All)", 
                           choices = select_var(df_base, "id"),
                           multiple = TRUE),
               selectInput(NS(id,"date"),"Select Date (default All)", 
                           choices = select_var(df_base, "date"),
                           multiple = TRUE),
               
               ###
               verbatimTextOutput(NS(id, "test")),
               ####
               
               actionButton(NS(id, "submit"), "Submit"),
               actionButton(NS(id, "refresh"), "Refesh Data"),
               #downloadButton(NS(id,"download"), "Save Report")
               )
             ,
             mainPanel(uiOutput(NS(id, "sumbox")))
           ))
}

## Generates the summary UI Output
## Used in ## Build Tbl Summary Report
summaryUI <- function(id, output) {
  output$sumbox <- renderUI({
    tagList(gt_output(NS(id, "summary")),
            downloadButton(NS(id, "download"), "Save Report"))
  })
}
## Genates Summary UI alternative comment
## Used in ## Build Tbl Summary Report
summaryUIalt <- function(id, output) {
  output$sumbox <- renderUI({
    strong("Selection does not have any observations")
  })
}



## Server
reportServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ## Accumaulates variables for tbl_summary
                 ## - pass to add
                 add_r <- reactive({
                   input$add
                 })
                 
                 ## Reloads df_base from disc
                 df_base_r <- reactiveVal(df_base)
                 
                 
                 ## Build tbl_summary report
                 ## - if add_r is NULL, then remove summary UI output
                 ## - else
                 ## 1. reload df_base
                 ## 2. set add as the add_r() reactive variable (locks the state of the variable)
                 ## 3. generate summaryUI output
                 ## -- updates the add variable as global_add if "All" is selected
                 observeEvent(input$submit,
                              summaryTbl()
                              )
                              
                              ## Reloads df_base from disc
                              observeEvent(input$refresh, {
                                df_base_r(read_df_base())
                                updateSelectInput(session, "id", "Select ID",
                                                  choices = select_var(df_base, "id"))
                                updateSelectInput(session, "date", "Select Date",
                                                  choices = select_var(df_base, "date"))
                              })
                              
                              ## Download Report
                              ## - uses summaryTbl_output to generate report
                              output$download <- downloadHandler(
                                filename = function() {
                                  paste("summary",Sys.Date(),".pdf")
                                  },
                                content = function(file){summaryTbl_output(file)}
                              )
                              
                              
                              
                              ## Functions **************************8
                              
                              ## SymmaryTbl
                              ## - generate the summary table
                              ## - If add_r NUlL remove the summaryUI 
                              ##   - render summaryUIalt (as else block bottom)
                              ## - Else 
                              ##   - If 'All" selected set add as global add
                              ##     - render summaryTbl
                              ##   - Else use selected variables
                              ##     - render summaryTbl
                              summaryTbl <- function() {
                                if (is.null(add_r())) {
                                  removeUI("#report-summary")
                                } else {
                                  df_filter <- filter_df(df_base, input$id, input$date)
                                  if (nrow(df_filter) !=  0) {
                                    add <- add_r()
                                    summaryUI(id, output)
                                    if ("All" %in% add) {
                                      add <- global_add
                                      output$summary <-
                                        render_gt(tbl_sum(df_filter, add, categorical))
                                    } else{
                                      output$summary <-
                                        render_gt(tbl_sum(df_filter, add, categorical))
                                    }
                                  } else {
                                    summaryUIalt(id, output)
                                  }
                                }
                              }
                              
                              ## Summary Tbl output
                              ## For generating download
                              ## - set df_filter based on inputs
                              ## - If "All" export with global_all
                              ## - Else export with add_r
                              ## export via gt_save and tbl_sum
                              summaryTbl_output <- function(file) {
                                message("HERE")
                                df_filter <-
                                  filter_df(df_base, input$id, input$date)
                                add <- add_r()
                                if ("All" %in% add) {
                                  add <- global_add
                                    gtsave(tbl_sum(df_filter, add, categorical),
                                           file)
                                } else {
                                    gtsave(tbl_sum(df_filter, add, categorical),
                                           file)
                                }
                                message("HERE2")
                              }
               })
}
