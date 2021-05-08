# Import libraries
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(Lahman)

# Read baseball data from Lahman library and generate my data frame


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
