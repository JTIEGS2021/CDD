##### Functions
# remove the pass ui
removePassUI <- function() {
  removeUI("#load-pass_submit")
  removeUI("#load-out")
  removeUI("#load-pass")
}


## Modules
# initial state passUI elements, removed in the server
passUI <- function(id) {
  tabPanel(
    "Load",
    textOutput(NS(id, "status")),
    textInput(NS(id, "pass"), label = ""),
    textOutput(NS(id, "out")),
    actionButton(NS(id, "pass_submit"), "submit")
  )
}

## Server
passServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 #Reactive Values
                 pass_status <- reactiveVal("Password")
                 pass_input <- reactiveVal("")
                 
                 # Status, password of admin
                 output$status <- renderText(pass_status())
                 
                 # Password logic
                 # - takes password (input$pass) and compares to global upload_password
                 # - if match
                 #  1. remove the password UI and add the load data UI
                 #  2. change status to admin
                 # - else output incorrect message
                 observeEvent(input$pass_submit, {
                   pass_input(input$pass)
                   if (pass_input() == upload_password) {
                     print("Pass correct")
                     removePassUI()
                     loadUI(id)
                     pass_status("Admin")
                   } else
                     output$out <-
                       renderText('Password is Incorrrect')
                 })
               })
}

