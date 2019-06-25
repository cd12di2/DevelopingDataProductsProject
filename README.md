
# DevelopingDataProductsProject

### Author: "SP"
### Date: "June 23, 2019"

## Shiny Application: Solar Type (DevelopingDataProductsCourseProject)

The Solar Type application is written in R for implementation
in Shiny.  The app allows users to select one of the ten nearest
Solar Types or Solar Analogs to our sun and displays some of its 
properties.  Solar Types and Solar Analogs are two categories of
stars that have similarities to the sun, with Solar Analogs being 
more closely matched.  Solar Twins, even more closely matched to 
our sun, are further away than the Solar Types and Analogs listed 
in the app and are not included.

When a star is selected by the user, its distance from the sun is 
displayed along with some current information about its potential 
planets.  The app uses the temperature data from the star and plots 
its radiation (black body) spectrum in comparison to the sun's.

The app also calculates the time it would take an ideal spacecraft
to reach the planet and plots the spacecraft's velocity vs. time
given spacecraft characteristics supplied by the user.  

Along with star selection, the following inputs are available to the 
user:

Ship Mass - The user can select ship mass using a slider.  The larger
the mass, the longer it will take for a ship to reach a star.

Propellant Mass Ratio - The ratio of a ship's propellant mass to its 
total mass.  It is expected that the ship will expend all of its 
propellant during the journey.  The higher the ratio of propellant, 
the the shorter the trip will be.  However, with higher propellant
ratios, less payload will be delivered.

Initial Velocity - Assumes that some effort to get the ship moving
at a high velocity prior to departing our solar system is provided.

Engine Power - The power of the engine.  A more powerful engine will
reduce trip time.

### Some notes:

The calculations for energy spectrum use the standard black-body formula.

The calculations for trip time use the standard rocket formula assuming
an Ion drive that runs 100% of the time.  

The combination of user selected parameters may not be realistic.  For 
instance, selecting the minimum mass for the ship with the maximum 
propellant ratio and the maximum engine power level may not be practical
since there would be minimal mass allowed for power generation.

The calculations are ideal and don't take into consideration the reality
of a power plant supplying power for the length of time needed to make 
the trip or whether the ship itself could maintain functionality for 
such a long trip.  

### References:

"Solar Analog", Wikipedia, https://en.wikipedia.org/wiki/Solar_analog, Accessed 06/20/2019

"Black body", Wikipedia, https://en.wikipedia.org/wiki/Black_body, Accessed 06/15/2019

"Rocket in Space", Hyperphysics, http://hyperphysics.phy-astr.gsu.edu/hbase/rocket2.html,
Accessed 06/18/2019

"No big planets at Alpha Centauri, but maybe small ones", Deborah Byrd, EarthSky, 
https://earthsky.org/space/no-big-planets-at-alpha-centauri-but-maybe-small-ones,
Accessed 06/20/2019

"Four Earth-sized planets detected orbiting the nearest sun-like star", Tim Stephens,
https://news.ucsc.edu/2017/08/tau-ceti-planets.html, Accessed 06/20/2019

"82 G. Eridani", Wikipedia, https://en.wikipedia.org/wiki/82_G._Eridani,
Accessed 06/20/2019

"Delta Pavonis", Wikipedia, https://en.wikipedia.org/wiki/Delta_Pavonis,
Accessed 06/20/2019

"HD 14412", Wikipedia, https://en.wikipedia.org/wiki/HD_14412, Accessed 06/20/2010

"HD 172051", Wikipedia, https://en.wikipedia.org/wiki/HD_172051, Accessed 06/20/2010

"HD 196761", Wikipedia, https://en.wikipedia.org/wiki/HD_196761, Accessed 06/20/2010


