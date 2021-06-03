# tutorial 06: DataFrames part 1

# MATRIX

brand = ["Company A", "Company A", "Company A"]
tier = ["Premium", "Economy", "Standard"]
quantity = [10, 100, 50]
price = [100, 10, 50]
cost = [30, 7, 25]


#1. Create Matrix 
mymatrix = [brand tier quantity price cost]

#how to intex a Matrix

# select the price column

myprice = mymatrix[:,4]

# select the Economy row

myeconomy = mymatrix[2,:]

#2. Calculate Revenue

myquantity = mymatrix[:,3]

myrevenue = myquantity .* price

# add Revenue Vector to Matrix

mymatrix = [mymatrix myrevenue]

# 2b. calculate Profit

mycost = mymatrix[:,5]

myprofit = myquantity .* (myprice .- mycost)

# add profit Vector to Matrix
mymatrix = [mymatrix myprofit]

# 2c calculate Profit

mymargin = myprofit ./ myrevenue

# add profit margin vector to Matrix

mymatrix = [mymatrix mymargin]

# 3. calculate totals for quantity, revenue and profit
mytotalquantity = sum(myquantity)

mytotalrevenue = sum(myrevenue)

mytotalprofit = sum(myprofit)

# 4. calcualte oberall profit margin

mytotalmargin = mytotalprofit / mytotalrevenue

# 5. create a new matrix for totals
metrics = ["Quantity", "Revenue", "Profit","Margin"]
totals = [mytotalquantity,mytotalrevenue,mytotalprofit,mytotalmargin]
mytotalmatrix = [metrics totals]


# save matrix
using DelimitedFiles

writedlm("tutorial_06/mymatrix.csv",mymatrix,',')


### TypedTables

using TypedTables

# create Table

mytable = Table(
    Brand = brand,
    Tier = tier,
    Quantity = quantity,
    Price = price,
    Cost = cost,
    Revenue = myrevenue,
    Profit = myprofit,
    Margin = mymargin
)

# how to vew Columns from a Table
mycolumn = mytable.Tier

# how to vie Wros from a Table
myrow = mytable[2,:]

vscodedisplay(mytable)

# save Table
using CSV
CSV.write("tutorial_06/mytable.csv",mytable)

### Pretty TypedTables

using PrettyTables

myprettytable = pretty_table(mytable)   # generate html code for a Table

# create function to save Table as HTML DelimitedFiles
function savehtml(filename,data)
    open("tutorial_06/$filename.html","w") do f
        pretty_table(f,data,backend = :html)
    end
end

# save PrettyTable as HTML filename

savehtml("myprettytable",mytable)


# DataFrames

using DataFrames

# convert Table into DataFrames

mydataframe = DataFrame(mytable)

# 1. Create DataFrame
df = DataFrame(
    Brand = brand,
    Tier = tier,
    Quantity = quantity,
    Price = price,
    Cost = cost
) 

# 2a. calculate Revenue
df.Revenue = df.Quantity .* df.Price 

df

# 2b. calcualte Profit
df.Profit = df.Quantity .* (df.Price .- df.Cost)

df

# 2c. calculate Profit Margin

df.Margin = df.Profit ./ df.Revenue

# 3. calculate totals for Quantity, Reneue and Profit 

dftotalquantity = sum(df.Quantity)
dftotalrevenue = sum(df.Revenue)
dftotalprofit = sum(df.Profit)

# 4. calculata overall Profti Margin

dftotalmargin = dftotalprofit / dftotalrevenue

# 5. Create a new DataFrame for totals

dftotasls = DataFrame(
    Quantity = dftotalquantity,
    Revenue = dftotalrevenue,
    Profit = dftotalprofit,
    Margin = dftotalprofit
)

#vscodedisplay
vscodedisplay(df)


CSV.write("tutorial_06/mydf.csv",df)

# save DataFrame as a HTML filename
savehtml("mydf",df)

# summary information

describe(df)

nrow(df)

ncol(df)

size(df)

# colum name functions

names(df)

propertynames(df)

rename(df,:Brand => :Company)

rename!(df,:Brand => :Company)

rename!(df,:Quantity => :Qty)

rename!(df,:Qty => :Quantity)


# how to index a DataFrame
# how to index entire column

mycolumn = df.Revenue

# how to index entire row

mycolumn = df[3,:]

# index individual element

mysubset = df.Tier[1]

# taking a subset

mysubset = df.Revenue[2:3]

mysubset = df[2:3,:]

mysubset = df[:,[:Tier, :Revenue]]

mysubset = df[2:3,[:Tier, :Revenue]]
