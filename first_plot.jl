using DelimitedFiles
EVDdata = DelimitedFiles.readdlm("EbolaDataConvertido.csv", ',')  #don't forget the delimiter ','
epidays = EVDdata[:, 1]  #Here ":" means all the entries in all rows of the specified columns, like Octave
allcases = EVDdata[:, 2] #ditto

using Plots #package
gr() #selected backend

plot(epidays, allcases)

plot(epidays, allcases,   #here are the data to be plotted, below are the attributes
title       = "West African EVD epidemic, total cases", 
xlabel    = "Days since 22 March 2014",
ylabel    = "Total cases to date (three countries)",
marker  = (:diamond, 8),  #note the use of  parentheses to group the marker attributes into a composite of attributes 
                          #and because we plot both the path and the points, we use plot rather than scatter
line         = (:path, "gray"),   #line attributes likewise put together as one unit by the use of parantheses
legend   = false,
grid        = false)    

savefig("WAfricanEVD.png")     #saved png format
