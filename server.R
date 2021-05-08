####################################
# Server                           #
####################################
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(Lahman)

a1<-Batting %>%
    group_by(playerID)%>%
    summarise(avg_HR = round(mean(HR, na.rm = TRUE)),
              career_HR = sum(HR, na.rm = TRUE),
              sum_H = sum(H, na.rm = TRUE),
              sum_AB = sum(AB, na.rm = TRUE))%>%
    mutate(bat_avg = round(sum_H/sum_AB,3))%>%
    select(playerID, bat_avg, avg_HR, career_HR) %>%
    arrange(desc(bat_avg))

a2<-a1%>%
    inner_join(HallOfFame, a1, by=c("playerID")) %>%
    filter((inducted == "Y") & (category == "Player"))%>%
    select(playerID, bat_avg, avg_HR, career_HR, yearID, category)

a3<- inner_join(a2, People, by=c("playerID")) %>%
    select(playerID, yearID, nameFirst,	nameLast,	weight,	height, birthCountry,
           bat_avg, avg_HR, career_HR, yearID, category)

p1<-Pitching %>%
    group_by(playerID)%>%
    summarise(avg_ERA = mean(ERA))

a4<-a3%>%
    left_join(p1, a3, by=c("playerID")) %>%
    select(playerID, yearID, nameFirst,	nameLast,	weight,	height, birthCountry,
           bat_avg, avg_HR, career_HR, avg_ERA, yearID, category)

df<-rename(a4, PlayerFirstName=nameFirst,
           PlayerLastName=nameLast,
           Year=yearID,
           Weight=weight,
           Height=height,
           CountryOfBirth=birthCountry,
           BattingAverage=bat_avg,
           AverageHomeRuns=avg_HR,
           CareerHomeRuns=career_HR,
           AverageERA=avg_ERA,
           Category=category)


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
