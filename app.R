#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


nearest_stars = c("Alpha Centauri A",
                  "Tau Ceti",
                  "82 Eridani",
                  "Delta Pavonis",
                  "V538 Aurigae",
                  "HD 14412",
                  "HR 4587",
                  "HD 172051",
                  "72 Herculis",
                  "HD 196761")
nearest_star_distances = c(4.37,11.9,19.8,19.9,39.9,41.3,42.1,42.7,46.9,46.9)
nearest_star_temperatures = c(5790,5344,5388,5604,5257,5432,5538,5610,5662,5415)
planets = c("Small Rocky Planets","Four Earth Size","Three Super Earths","Non Detected","No Data","Non Detected","Possible Companion Red Dwarf","Non Detected","Non Detected","Non Detected")

suntemp = 5778

starlist <- as.list(nearest_stars)

h = 6.62607004e-34                        # m2kg/s  Js
c = 2.99792458e8                          # m/s
k = 1.38064852e-23                        # m2kg/s2K  J/K
wavelength = seq(10,3000, by=10)          # nm
v = 1e9*c/wavelength                      # Hz

black_body<-data.frame

black_body <- ((1e9*8*pi*h*c/(wavelength/1e9)^5)/(exp(h*v/(k*suntemp))-1))/1e14

temp <- ((1e9*8*pi*h*c/(wavelength/1e9)^5)/(exp(h*v/(k*nearest_star_temperatures[1]))-1))/1e14
black_body<-cbind(black_body,temp)


getDistance<-function(time,m,dm,v0,mu) {
  
  t1<-(m-sqrt((m/dm-1)*m*dm*exp(v0/mu)))*time/dm
  t2<-m*time/dm - ((m-dm*t1/time)^2)/(m*dm*exp(v0/mu)/time) - t1
  mprime<-m-dm*t1/time
  x1<-v0*time + mu*((time*m/dm-t1)*log(1-dm*t1/(time*m))+t1)
  x2<-mu*((time*mprime/dm-t2)*log(1-dm*t2/(time*mprime))+t2)
  x<-x1+x2
  #cat(sprintf("\nt1 = %f sec\n",t1))
  #cat(sprintf("t2 = %f sec\n",t2))
  #cat(sprintf("m' = %f mass units\n",mprime))
  #cat(sprintf("x1 = %f m\n",x1))
  #cat(sprintf("x2 = %f m\n",x2))
  x
}

getTime<-function(distance,m,dm,v0,power) {
  
  time = 0
  tdistance = 0
  tries = 0
  convertiontoyear = 60*60*24*365.25
  mydistance=distance*9.561e15
  myv0 = v0*1000
  mu = sqrt(2*1000*power*time/(dm*m))
  
  while ((tries<10000) && (tdistance<mydistance)) {
    time=time+10
    mu = sqrt(2*1000*power*time*convertiontoyear/(dm*m))
    tdistance<-getDistance(time*convertiontoyear,m,dm*m,myv0,mu)
    tries=tries+1
  }
  
  #cat(sprintf("\nmu = %f m/s\n",mu))
  #cat(sprintf("time = %f years\n",time))
  #cat(sprintf("distance          = %f ly\n",tdistance/9.561e15))
  #cat(sprintf("required distance = %f ly\n",mydistance/9.561e15))
  
  time
  
}

getVelocities<-function(time,m,dm,v0,power) {
  
  convertiontoyear = 60*60*24*365.25
  mtime = time*convertiontoyear
  mu = sqrt(2*1000*power*mtime/(dm*m))
  t1<-(m-sqrt((1/dm-1)*m*m*dm*exp(1000*v0/mu)))*mtime/(m*dm)
  t2<-mtime/dm - ((m-m*dm*t1/mtime)^2)/(m*m*dm*exp(1000*v0/mu)/mtime) - t1
  mprime<-m-m*dm*t1/mtime

  times1<-seq(0,t1,by=t1/99) 
  velocities1<-(1000*v0 + mu*log(m/(m-m*dm*times1/mtime)))
  
  times2<-seq(t1,(t1+t2),by=t2/99) 
  velocities2<-velocities1[length(velocities1)]-(mu*log(mprime/(mprime-m*dm*(times2-t1)/mtime)))
  
  times <- c(times1,times2)
  times<-times/convertiontoyear
  velocities <- c(velocities1,velocities2)
  
  #cat(sprintf("\nt1 = %f sec\n",t1))
  #cat(sprintf("t2 = %f sec\n",t2))

  df<-data.frame(times,velocities)
  
}
  
#mytime<-getTime(1,10,0.8,0,100)
#vdata<-getVelocities(mytime,10,0.8,0,100)
#print(vdata)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
  tags$head(
    tags$style(HTML("hr {border-top: 1px solid #000000;}"))
  ),
 
  # Application title
  titlePanel("Travel to Near Solar Type Stars using Ion Engine"),
  
  # Sidebar with a slider inputs 
  sidebarLayout(
    sidebarPanel(
      hr(),
      selectInput("star","Choose a Star:",choices=starlist),
      textOutput("result"),
      textOutput("result3"),
      textOutput("result2"),
      hr(),
      sliderInput("Mass","Total Ship Mass (kg)",10,10000,5),
      sliderInput("Propellant","Propellant Fraction of Total Mass",0.10,0.90,0.50),
      sliderInput("Vnot","Initial Ship Velocity (km/s)",0,100,5),
      sliderInput("Power","Engine Power (kW)",10,1000,50),
      hr()
    ),
    
    # Show a plot
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    )
    
  )

)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$result <- renderText({
    paste("Distance from Sol: ",nearest_star_distances[match(input$star,nearest_stars)]," Light Years")
  })
  
  output$result3 <- renderText({
    paste("Planetary System: ",planets[match(input$star,nearest_stars)])
  })
  
  output$plot1<-renderPlot({
    temp<-((1e9*8*pi*h*c/(wavelength/1e9)^5)/(exp(h*v/(k*nearest_star_temperatures[match(input$star,nearest_stars)]))-1))/1e14
    plot(x=wavelength,y=black_body[,1],xlab="Wavelength (nm)",ylab="Power Density (W/m^2)",main="Energy Spectrum",type="l",col="blue")
    lines(x=wavelength,y=temp,type="l",col="red")
    legend("topright",legend=c("Sol",input$star),col=c("red","blue"),lty=1,cex=0.8) 
  })
  
  output$result2 <- renderText({
    mydistance<-nearest_star_distances[match(input$star,nearest_stars)]
    mym<-input$Mass
    mydm<-input$Propellant
    myv0<-input$Vnot
    mypower<-input$Power
    mytime = getTime(mydistance,mym,mydm,myv0,mypower)
    paste("Trip Time:",mytime," Years")
  })
  
  output$plot2<-renderPlot({
    mydistance<-nearest_star_distances[match(input$star,nearest_stars)]
    mym<-input$Mass
    mydm<-input$Propellant
    myv0<-input$Vnot
    mypower<-input$Power
    mytime = getTime(mydistance,mym,mydm,myv0,mypower)
    vdata<-getVelocities(mytime,mym,mydm,myv0,mypower)
    #print(vdata)
    plot(x=vdata$times,y=vdata$velocities/3e8,xlab="Time (years)",ylab="Velocity (c)",main="Ship Speed",type="l",col="blue")
})
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

