library(shiny)
library(shiny.tailwind)
library(shiny.i18n)
library(shinyjs)
library(bundle)
library(dplyr)
library(xgboost)
library(workflows)
library(tidymodels)
library(forcats)

bundled_model = readRDS("devwages.rds")
model = bundle::unbundle(bundled_model)


# Define UI for application that draws a histogram
ui <- div(
    tags$head(
      tags$meta(name = "viewport",
                content="width=device-width, initial-scale = 1",
                title = "Web Devs Wages"),
      # Load Tailwind CSS Just-in-time
      includeCSS("www/styles.css"),
      use_daisyui(),
      useShinyjs()
      ),
    
    tags$body(
      tags$div(class="flex flex-col min-h-screen",
      
      # NavBar
      
      div(class = "navbar bg-neutral text-neutral-content justify-center",
          tags$button(class = "btn btn-ghost text-xl", "Greek Devs' Salary")
      ),
      
      # Main Card 

        div(class="hero flex-grow",
          div(class="hero-content",
              div(class="card shadow-2xl bg-base-100 md:shrink-0 md:max-w-md sm:max-w-full",
                  tags$form(class = "card-body",
                            
                            # Step 1 : Personal Information
                            
                            # div(id = "step1",
                            #   div(class = "wrapper-card",
                            #     div(class = "wrapper-card-title-questions p-4",
                            #     div(class = "title",
                            #         h2(class="text-2xl font-bold mb-4 text-center", 
                            #        tags$span(class = "bold", "A. "),
                            #        "Personal Info")),
                            #     
                            #     tags$div(class = "question",
                            #              tags$div(class = "question-title",
                            #              tags$h4(
                            #                "Educational Level"
                            #              )),
                            #              selectInput(inputId = "education_level", label = "",
                            #                          c("Primary" = "Primary",
                            #                            "High School" = "HighSchool",
                            #                            "Post Secondary" = "PostSecond",
                            #                            "Bachelor" = "Bachelor",
                            #                            "Master" = "Master",
                            #                            "PhD" = "PhD")))
                            #     
                            #     ),
                            #              
                            #     
                            #     div(class = "card-actions justify-end",
                            #         actionButton("nextBtn1", "Next")))
                            #     ),
                            # 
                            # Step 2 - Experience
                            
                            div(id = "step2",
                                h2(class="text-2xl font-bold mb-4 text-center", 
                                   tags$span(class = "bold", "B. "),
                                   "Experience"),
                                
                                tags$div(class = "question",
                                         tags$div(class = "question-title",
                                                  tags$h4(
                                                    "Years Programming"
                                                  )),
                                         sliderInput(inputId = "yearsprogr",
                                                      label = "",
                                                      value = 5, 
                                                      min = 0, 
                                                      max = 30, 
                                                      step = 1)
                                         ),
                                
                                tags$div(class = "question",
                                         tags$div(class = "question-title",
                                                  tags$h4(
                                                    "Personal Projects"
                                                  )),
                                         selectInput("pers_proj", label = "",
                                                     c("Yes" = "Yes",
                                                       "No" = "No"))),
                                
                            div(class = "card-actions justify-end",
                                    actionButton("nextBtn2", "Next")) 
                                ),
                            
                            # Step 3 - Job Details
                            
                            div(id = "step3",  class = "hidden",
                                h2(class="text-2xl font-bold mb-4 text-center", 
                                   tags$span(class = "bold", "C. "),
                                   "Job Details"),
                                
                                tags$div(class = "question",
                                         tags$div(class = "question-title",
                                                  tags$h4(
                                                    "Company Employees"
                                                  )),
                                         selectInput("company", label = "",
                                                     c("1 to 10 employees" = "1to10",
                                                       "11 to 50 employees" = "11to50",
                                                       "51 to 100 employees" = "51to100",
                                                       "101 to 200 employees" = "101to200",
                                                       "201 to 500 employees" = "201to500",
                                                       "501+" = "501plus"))),
                                
                                
                                tags$div(class = "question",
                                         tags$div(class = "question-title",
                                                  tags$h4(
                                                    "Job Type"
                                                  )),
                                         selectInput("job_type", label = "",
                                                     c("Onsite" = "Onsite",
                                                       "Hybrid" = "Hybrid",
                                                       "Remote" = "Remote"))),
                                
                                tags$div(class = "question",
                                         tags$div(class = "question-title",
                                                  tags$h4(
                                                    "Employer Place"
                                                  )),
                                         selectInput("employer_place", label = "",
                                                     c("Greece" = "Greece",
                                                       "Abroad" = "Abroad"))),
                                
                                
                                
                                div(class = "card-actions justify-end",
                                    actionButton("submit", "Submit"))
                                
                                ),
                            
                            # # Step 4 - Technologies
                            # 
                            # div(id = "step4", class = "hidden",
                            #     h2(class="text-2xl font-bold mb-4 text-center", 
                            #        tags$span(class = "bold", "D. "),
                            #        "Technologies"),
                            #     
                            #     div(class = "card-actions justify-end",
                            #         actionButton("nextBtn4", "Next"))
                            #     ),
                            # 
                            # # Step 5 - Sub-Industry
                            # 
                            # div(id = "step5",  class = "hidden",
                            #     h2(class="text-2xl font-bold mb-4 text-center", 
                            #        tags$span(class = "bold", "E. "),
                            #        "Sub-Industry"),
                            #     
                            #     div(class = "card-actions justify-end",
                            #         actionButton("nextBtn5", "Sumbit"))),
                            # 
                            # 
                            # Results
                            
                            div(id = "results",  class = "hidden",
                                h2(class="text-2xl font-bold mb-4 text-center", 
                                   "Results"),
                                div(class = "font-bold text-1xl text-center",
                                div(
                                  p("Your expected annual wage is:")
                                ),
                                textOutput("result"),
                                ),
                                
                                div(class = "card-actions justify-end",
                                    actionButton("reset", "Reset")))
                            
                            )))),
      
      
      
      ## Footer
      
      tags$footer(class="footer footer-center  p-4 bg-white text-base-content",
                  tags$div(class = "footer-text",
                    tags$div(tags$a(href = "https://www.stesiam.com/", target = "_blank", 
                                    class ="link link-hover",
                                    "stesiam,")),
                    tags$div(tags$p(" 2024 ©"))
                  )
      ),
      
      
    tags$script("www/script.js")
      
    ))

)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # observeEvent(input$nextBtn1, {
  #   shinyjs::hide("step1")
  #   shinyjs::show("step2")
  # })
  
  observeEvent(input$nextBtn2, {
    shinyjs::hide("step2")
    shinyjs::show("step3")
  })
  
  observeEvent(input$submit, {
    shinyjs::hide("step3")
    shinyjs::show("results")
  })
  
  # observeEvent(input$nextBtn4, {66
  #   shinyjs::hide("step4")
  #   shinyjs::show("step5")
  # })
  # 
  # observeEvent(input$submit, {
  #   shinyjs::hide("step5")
  #   shinyjs::show("results")
  # })
  
  observeEvent(input$reset, {
    shinyjs::hide("results")
    shinyjs::show("step2")
  })
  output$result = renderText({

    test_data = dplyr::tibble(
      YearsProgr = input$yearsprogr,
      PersonalProj = input$pers_proj,
      Gender = NA,
      Company = input$company,
      Employer = input$employer_place,
      WorkType = input$job_type,
      Studies = NA)
    
    wage = predict(model, new_data = test_data)$.pred
    
    return(round(wage, digits = 0))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
