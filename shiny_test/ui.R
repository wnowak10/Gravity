# ui.R

# assign numeric values to options
choices=c("Percent White"=1, "Percent Black"=2,
          "Percent Hispanic"=3, "Percent Asian"=4,"Percent Clinton" =5,
          "Percent Trump"=6)


shinyUI(fluidPage(
  # title
  titlePanel("USA County Correlations"),
  
  # top row
  fluidRow(
    column(3,helpText("Create demographic maps with 
               information from the 2010 US Census and 2016 election.")),
    
    column(3, selectInput("var", 
                          label = "Choose an x-axis variable to display",
                          choices = choices,
                          selected = 1)),
    
    column(3, selectInput("var2", 
                label = "Choose a y-axis variable to display",
                choices = choices,
                selected = 6))
    
  ),
  
  # sidebar and main panel
  sidebarLayout(
    # side panel
    sidebarPanel(
      helpText("Choose range of interest for x, y variables"),
      
      sliderInput("range", 
                  label = "X-axis range of interest:",
                  min = 0, max = 100, value = c(0, 100)),
      
      sliderInput("range2", 
                  label = "Y-axis range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ),
    #main panel
    mainPanel(plotOutput("plot2"))
  ),
  
  # bottom row
  fluidRow(
    # maps along bottom row
    column(6,plotOutput("map")),
    column(6,plotOutput("map2"))
    )
  
))