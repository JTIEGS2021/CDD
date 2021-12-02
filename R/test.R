shinyApp(
  ui = basicPage(actionButton("go", "Go")),
  server = function(input, output, session) {
    observeEvent(input$go, {
      insertUI("#go", "afterEnd",
               actionButton("dynamic", "click to remove"))
      
      # set up an observer that depends on the dynamic
      # input, so that it doesn't run when the input is
      # created, and only runs once after that (since
      # the side effect is remove the input from the DOM)
      observeEvent(input$dynamic, {
        removeUI("#dynamic")
      }, ignoreInit = TRUE, once = TRUE)
    })
  }
)
