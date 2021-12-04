# Tab Page
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
               actionButton(NS(id, "refresh"), "Refesh Data")
             ),
             mainPanel(uiOutput(NS(id, "sumbox")))
           ))
}

## Geneates the summary UI Output
summaryUI <- function(id, output) {
  output$sumbox <- renderUI({
    gt_output(NS(id, "summary"))
  })
}

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
                 df_base_r <- reactiveVal(df_base)
                 
                 
                 ## Build tbl_summary report
                 ## - if add_r is NULL, then remove summary UI output
                 ## - else
                 ## 1. reload df_base
                 ## 2. generate summaryUI output
                 observeEvent(input$submit, {
                   if (is.null(add_r())) {
                     removeUI("#report-summary")
                   } else {
                     df_filter <- filter_df(df_base, input$id, input$date)
                     if (nrow(df_filter) !=  0) {
                       add <- add_r()
                       summaryUI(id, output)
                       if (add == "All") {
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
                 })

                 observeEvent(input$refresh, {
                   df_base_r(read_df_base())
                   updateSelectInput(session, "id", "Select ID",
                                     choices = select_var(df_base, "id"))
                 })
               })
}