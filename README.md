A program that will generate around 1 million stars in json format. Then I can go into the Json and add special info before loading into shipTerm
Can I use something like Traveller Star codes to randomly generate info strings about each star like recourses
factions, and number of planets? I'd need to write some kind of parser
Lets start by copying the shipTerm star gen code and making sure we can use 
the star structs to make some json objects. 

Then I'll want to automate the description field to the effect of 
"A [StarClass] Star, owned by [Faction] with [Num Planets]. The system is rich in
[Some resources] that collected. There is also a trading post orbiting [Planet Name]."
