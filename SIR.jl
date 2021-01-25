using DelimitedFiles
EVDdata = DelimitedFiles.readdlm("EbolaDataConvertido.csv", ',')
EVDdata[end-9:end, :]#end-9:end is a range with 10 elements

#there are missing values, let's convert then to 0
rows, cols = size(EVDdata)
for j = 1:cols
    for i = 1:rows  # this order goes does one column at a time
       if !isdigit(string(EVDdata[i, j])[1])
         EVDdata[i,j] = 0
       end
   end
end

#extract the data
epidays = EVDdata[:,1]
EVDcasesbycountry = EVDdata[:, [4, 6, 8]]

#load Plots and plot them
using Plots
gr()
plot(epidays, EVDcasesbycountry)

plot(epidays, EVDcasesbycountry,
marker = ([:octagon :star7 :square], 9),
label     = ["Guinea" "Liberia" "Sierra Leone"],
title      = "EVD in West Africa, epidemic segregated by country",
xlabel   = "Days since 22 March 2014",
ylabel   = "Number of cases to date",
line = (:scatter)
)
#cool, the SIR now...
#S = suscetíveis, muda em função do tempo: S(t)
#I = infecctadas
#R = infecctadas mas não mais infecciosas
function updateSIR(popnvector)
    susceptibles = popnvector[1];
    infecteds    = popnvector[2]; 
    removeds     = popnvector[3];
    newS = susceptibles - lambda*susceptibles*infecteds*dt
    newI = infecteds + lambda*susceptibles*infecteds*dt - gam*infecteds*dt  #note abbreviation for gamma (see below)
    newR = removeds + gam*infecteds*dt
    return [newS newI newR]   # NB! spaces only to make this a one row of a two-dimensional array
    #                   and note the use of "return" to specify what the function output should be 
end

# first we set the parameters
dt = 0.5                    # so we are taking two steps per day
lambda = 1/200; gam = 1/10  #note that gamma is a function in the stats packages, so let's not use it as a name

# then we specify the input vector to the function
s, i, r = 1000., 10, 20  # multiple assignment
vec = [s i r]         # followed by creating the input vector; spaces again so that it is a row of an array
updateSIR(vec)        # finally the actual function call to test the function

# set the values that define the current run
lambda = 1/20000   # infection rate parameter (assumes rates are per day)
gam = 1/10       # recovery rate parameter  (ditto)
dt = 0.5         # length of time step in days
tfinal = 610;    # respecting community values: lowercase only in the names 
s0 = 10000.0     # initial susceptibles, note that we use the  type Float64 from the start
i0 = 1.          # initial infecteds; set this to 1. to  mimic an epidemic with an index case
r0 = 0.          # not always the case, of course

# initialise the current run
nsteps = round(Int64, tfinal/dt)    #round() ensure that nsteps is an integer
resultvals = Array{Float64}(undef, nsteps+1, 3)  #initialise array of type Float64 to hold results
timevec = Array{Float64}(undef, nsteps+1)        # ... ditto for time values
resultvals[1,:] = [s0, i0, r0]  # ... and assign them to the first row
timevec[1] = 0.                 # also Float64, of course.

# execute the current run
for step  = 1:nsteps
    resultvals[step+1, :] = updateSIR(resultvals[step, :])  # NB! pay careful attention to the rows being used
    timevec[step+1] = timevec[step] + dt
end

plot(timevec, resultvals)
plot(timevec, resultvals,  # we should of course at a minimum provide some labels
title  = "SIR results",
xlabel = "Epidemic day",
ylabel = "Population size",
)
savefig("SIR Model.png")
