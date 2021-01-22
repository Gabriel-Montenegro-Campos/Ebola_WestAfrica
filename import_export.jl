using DelimitedFiles
ebola = DelimitedFiles.readdlm("EbolaData.csv", ',') #importing data in CSV

using Dates
Dates.DateTime(ebola[1,1], "d u y") #convert data format to day-mon-year
#use a for loop 
col1 = ebola[:, 1]  # the colon means all the data in the column, the 1 means the first column
for i = 1:length(col1)
    col1[i] = Dates.DateTime(col1[i], "d u y")  # note that this replaces the previous value in col1[i]
end #:)
col1

Dates.datetime2rata(col1[1]) #convert the days since 01/01/0001
dayssincemar22(x) = Dates.datetime2rata(x) - Dates.datetime2rata(col1[54])
epidays = Array{Int64}(undef,54)
for i = 1:length(col1)
    epidays[i] = dayssincemar22(col1[i])
end #the days since March 22, the first day of the epidemic outbreak
ebola[:, 1] = epidays
DelimitedFiles.writedlm("EbolaDataConvertido.csv", ebola, ',')
