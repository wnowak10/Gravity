# server.R
# load libraries
library(maps)
library(ggplot2)
library(mapproj)
# this is R data set which contains 
#data on demographics per county and 
# also election data
counties <- readRDS("data/counties.rds")
# this file contains percent_map function. this 
# is from R shiny tutorial http://shiny.rstudio.com/tutorial/lesson5/
source("data/helpers.R")

  
shinyServer(
  function(input, output) {
    
    # build outputs to display
    output$plot2 <- renderPlot({ 
      
      # create possible x, y vars for scatterplot
      x = switch(input$var,
                 "1" = counties$white,
                 "2" = counties$black,
                 "3" = counties$hispanic,
                 "4" = counties$asian,
                 "5" = counties$perc_Clinton,
                 "6" = counties$perc_Trump)
      y = switch(input$var2,
                 "1" = counties$white,
                 "2" = counties$black,
                 "3" = counties$hispanic,
                 "4" = counties$asian,
                 "5" = counties$perc_Clinton,
                 "6" = counties$perc_Trump)
      
      #make scatterplot in ggplot
      ggplot(counties, aes(x,y))  + 
        geom_point(col=rgb(.5,0,0,alpha=.2))+
        geom_smooth(method = 'lm',col=rgb(0,0,.5,alpha=.2))+
        scale_x_continuous(limits=c(input$range[1],input$range[2])) + 
        scale_y_continuous(limits=c(input$range2[1],input$range2[2]))+
        # add marginal rug
        geom_rug(col=rgb(.5,0,0,alpha=.2))+
        xlab(input$var)+
        labs(title = "Demographic correlations")
    })
    
    # testing  
    output$what_input = renderText(input$var)
    
    # create first map
    output$map <- renderPlot({
      args <- switch(input$var,
                     "1" = list(counties$white, "darkgreen", "% White"),
                     "2" = list(counties$black, "black", "% Black"),
                     "3" = list(counties$hispanic, "darkorange", "% Hispanic"),
                     "4" = list(counties$asian, "darkviolet", "% Asian"),
                     "5" = list(counties$perc_Clinton, "darkblue", "% Clinton"),
                     "6" = list(counties$perc_Trump, "darkred", "% Trump"))
      args$min <- input$range[1]
      args$max <- input$range[2]
      # call percent_map function with given argument
      do.call(percent_map, args)
    })
    
    # create second map
    output$map2 <- renderPlot({
      args <- switch(input$var2,
                     "1" = list(counties$white, "darkgreen", "% White"),
                     "2" = list(counties$black, "black", "% Black"),
                     "3" = list(counties$hispanic, "darkorange", "% Hispanic"),
                     "4" = list(counties$asian, "darkviolet", "% Asian"),
                     "5" = list(counties$perc_Clinton, "darkblue", "% Clinton"),
                     "6" = list(counties$perc_Trump, "darkred", "% Trump"))
      args$min <- input$range[1]
      args$max <- input$range[2]
      do.call(percent_map, args)
    })
    
  }
)