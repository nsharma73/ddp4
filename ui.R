# Import libraries
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(Lahman)

# Read baseball data from Lahman library and generate my data frame
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


####################################
# User interface                   #
####################################

ui <- fluidPage(theme = shinytheme("cerulean"),

                # Page header
                headerPanel('Baseball Hall of Fame Players'),
                HTML("<h5>The app uses Lahman's baseball data to display player
                     names. Please input country name, weight, height and year range.
                     Note that when sorting the data will be displayed in ascending
                     order for Batting Average and descending order for Earned Run Average
                     (ERA)</h4>"),
                # Input values
                sidebarPanel(
                    HTML("<h3>Input parameters</h3>"),
                    # outlook -> CountryOfBirth
                    selectInput("CountryOfBirth", label = "Player Country Of Birth:",
                                choices = list("United States" = "USA",
                                               "Panama" = "Panama",
                                               "Dominican Republic" = "D.R.",
                                               "Puerto Rico" = "P.R.",
                                               "Cuba" = "Cuba",
                                               "Venezuela" = "Venezuela",
                                               "Canada" = "CAN",
                                               "Netherlands" = "Netherlands"),
                                selected = "United States"),

                    # Input: Specification of range within an interval ----
                    sliderInput("Weight", "Weight Range:",
                                min = 125, max = 250,
                                value = c(140,200)),

                    sliderInput("Height", "Height Range:",
                                min = 65, max = 82,
                                value = c(70,80)),

                    sliderInput("Year", "Year:",
                                min = 1936, max = 2018,
                                value = c(1936,2018), sep = ""),

                    awesomeRadio(
                        inputId = "Id003",
                        label = "Sort Data By:",
                        choices = c("BattingAverage",
                                    "AverageERA"),
                        #selected = "BattingAverage",
                        status = "warning"
                    ),

                    actionButton("submitbutton", "Submit", class = "btn btn-primary")
                ),

                mainPanel(
                    tags$label(h3('Status/Output')), # Status/Output Text Box
                    verbatimTextOutput('contents'),
                    tableOutput('tabledata') # Prediction results table

                )
)
