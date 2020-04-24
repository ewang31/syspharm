#Load packages

# Load relevant libraries.
if(!require('ggplot2')) {
    install.packages('ggplot2')
    library('ggplot2')
}
if(!require('gridExtra')) {
    install.packages('gridExtra')
    library('gridExtra')
}
if(!require('plotly')) {
    install.packages('plotly')
    library('plotly')
}
if(!require('shiny')) {
    install.packages('shiny')
    library('shiny')
}
if(!require('reshape')) { 
    install.packages('reshape')
    library('reshape')
}
if(!require('readr')) { 
    install.packages('readr')
    library('readr')
}
library('R.matlab')

urlfile = "https://raw.githubusercontent.com/ewang31/syspharm/master/helth_unhelth.csv"
health<-data.frame(read_csv(url(urlfile)))


# Define UI for application that draws a histogram
dodge <- position_dodge(width=1)
MAX = round(as.numeric(apply(data,2,max)), digits=2)
MIN = round(as.numeric(apply(data,2,min)), digits=2)

# Define UI for application that draws violin plots
ui <- fluidPage(
    titlePanel('PopPK analysis for Levodopa in subpopulations'),
    tabsetPanel(
        tabPanel('Simulations', plotlyOutput('Plot')),
        tabPanel('AUC',
                 fluidRow(
                     column(6,
                            plotlyOutput('vp')
                     ),
                     column(6,
                            plotlyOutput('vp2')
                     ),
                 )
                 ),
        tabPanel('Cmax'),
        tabPanel('Cmin')
    ),
    hr(),
    fluidRow(
        column(4,
               radioButtons("radio", label = "Choose a Scenario",
               choices = list("Inhaled" = 1, 
                              "Oral" = 2), 
               selected = 1)
               ), 
        column(8, 
               wellPanel(
                   h4('Violin plots'),
                   div('The violin plots display the distribution of area under the curve (AUC) for dopamine in the brain by gender. The plots are divided into two scenarios: Parkinson Disease vs. Healthy and Inhaled vs. Oral administration'),
                   br(),
                   h4('Scatter plots'),
                   div('The scatter plots show the values of peripheral compartment volume V2 (L) versus central compartment volume V1 (L) for each subpopulation.')
               ))))

# Server logic

server <- function(input, output) {
    output$vp = renderPlotly({
        fig <- health %>%
            plot_ly(type = 'violin')
        fig <- fig %>%
            add_trace(
                x = ~Gender[health$Health == 'Diseased'],
                y = ~AUC[health$Health == 'Diseased'],
                legendgroup = 'PD',
                scalegroup = 'PD',
                name = 'PD',
                box = list(
                    visible = T
                ),
                meanline = list(
                    visible = T
                ),
                color = I("red")
            )
        
        fig <- fig %>%
            add_trace(
                x = ~Gender[health$Health == 'Healthy'],
                y = ~AUC[health$Health == 'Healthy'],
                legendgroup = 'Healthy',
                scalegroup = 'Healthy',
                name = 'Healthy',
                box = list(
                    visible = T
                ),
                meanline = list(
                    visible = T
                ),
                color = I("green")
            )
        
        fig <- fig %>%
            layout(
                title = "AUC distributions between Parkinson's Disease vs. healthy patients",
                xaxis = list(
                    title = "Gender"
                ),
                yaxis = list(
                    title = "AUC of dopamine levels in brain",
                    zeroline = F
                ),
                violinmode = 'group'
            )
    })
    output$vp2 = renderPlotly({
        fig2 <- health %>%
            plot_ly(type = 'violin')
        fig2 <- fig2 %>%
            add_trace(
                x = ~Health[health$Dosed == 'Dosed'],
                y = ~AUC[health$Dosed == 'Dosed'],
                legendgroup = 'Dosed',
                scalegroup = 'Dosed',
                name = 'Dosed',
                box = list(
                    visible = T
                ),
                meanline = list(
                    visible = T
                ),
                color = I("red")
            )
        
        fig2 <- fig2 %>%
            add_trace(
                x = ~Health[health$Dosed == 'Not Dosed'],
                y = ~AUC[health$Dosed == 'Not Dosed'],
                legendgroup = 'Not Dosed',
                scalegroup = 'Not Dosed',
                name = 'Not Dosed',
                box = list(
                    visible = T
                ),
                meanline = list(
                    visible = T
                ),
                color = I("green")
            )
        
        fig2 <- fig2 %>%
            layout(
                title = "AUC distributions between Levodopa dosing in PD vs. healthy patients",
                xaxis = list(
                    title = "Health Condition"
                ),
                yaxis = list(
                    title = "AUC of Dopamine levels in brain",
                    zeroline = F
                ),
                violinmode = 'group'
            )
    })}
# Run the app
shinyApp(ui, server)