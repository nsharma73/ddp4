####################################
# Server                           #
####################################
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(Lahman)
server <- function(input, output, session) {

    # Input Data
    datasetInput <- reactive({
        if(input$Id003 == 'BattingAverage') {
            app_data<-df%>%
                filter(  CountryOfBirth == input$CountryOfBirth &
                             (Weight >= input$Weight[1]
                              & Weight <= input$Weight[2]) &
                             (Height>=input$Height[1]
                              & Height <=input$Height[2]) &
                             (Year>=input$Year[1] & Year<=input$Year[2]))%>%
                select(PlayerFirstName, PlayerLastName, BattingAverage,
                       AverageHomeRuns, CareerHomeRuns, AverageERA)%>%
                arrange(desc(BattingAverage))
        }
        else
        {    app_data<-df%>%
            filter(  CountryOfBirth == input$CountryOfBirth &
                         (Weight >= input$Weight[1]
                          & Weight <= input$Weight[2]) &
                         (Height>=input$Height[1]
                          & Height <=input$Height[2]) &
                         (Year>=input$Year[1] & Year<=input$Year[2]))%>%
            select(PlayerFirstName, PlayerLastName, BattingAverage,
                   AverageHomeRuns, CareerHomeRuns, AverageERA)%>%
            arrange((AverageERA))}

        print(app_data)


    })

    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton>0) {
            isolate("Query complete.")
        } else {
            return("Server is ready to query baseball data.")
        }
    })

    # Results table
    output$tabledata <- renderTable({
        if (input$submitbutton>0) {
            isolate(datasetInput())
        }
    },digits = 3,)

}
