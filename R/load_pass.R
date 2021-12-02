passUI <- function(id) {
  # Static Component
  # Dynamic

  tabPanel("Load",
           textOutput(NS(id, "status")),
           textInput(NS(id, "pass"),label =""),
           textOutput(NS(id, "out")),
           actionButton(NS(id, "pass_submit"), "submit")
  )
}

passServer <- function(id) {
  moduleServer(id,
              
               function(input, output, session) {
                 pass_status <- reactiveVal("Password")
                 pass_input <- reactiveVal("")
                 
                 output$status <- renderText(pass_status())
                 
                 observeEvent(input$pass_submit, {
                   pass_input(input$pass)
                   
                   if(pass_input() == upload_password){
                      print("Pass correct")
                     removeUI("#load-pass_submit")
                     removeUI("#load-out")
                     removeUI("#load-pass")
                     
                      insertUI("#load-status", "afterEnd",
                               tagList(
                                 fileInput(NS(id, "upload"), NULL, accept = c(".xlsx")),
                                 numericInput(
                                   NS(id, "upload_n"),
                                   "Check Rows",
                                   value = 5,
                                   min = 1,
                                   step = 1
                                 ),
                                 tableOutput(NS(id, "head")),
                                 verbatimTextOutput(NS(id, "upload_name_check")),
                                 textOutput(NS(id, "upload_conf"))
                               ))
                               
                      pass_status("Admin")       
                  
                   } else
                     output$out <- renderText('Password is Incorrrect')
                 })
                 
                 #output$out <- renderText(pass_input())
               })
}
