# Tab Page
reportsUI <- function(id) {
  tabPanel("Reports", 
          h2("Reports Summary"),
          gt_output(NS(id, "summary")))
}

reportServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$summary <- render_gt(
                   expr = tbl_sum(df_base, add, categorical)
                 )}
               )
}