# tutorial 12

# Timetypes

using Dates

using DataFrames, CSV

df_dates = DataFrame(CSV.File("tutorial_12/dates.csv", delim='#', types=[String]))

# add index numbers

df_dates.id = 1:nrow(df_dates)


df_dates = select!(df_dates, :id, :)

# set up formats in vector

formats_dates = [
"y-m-d",
"y U d",
"d U y",
"U d, y",
"y.m.d",
"y/m/d",
"d.m.y",
"d/m/y",
"d-m-y",
"m/d/y",
"m-d-y",
"m-d-y",
"m/d/y",
"m/d/y",
]

# paste Strings into Type Dates

df_dates.ISOdates = Date.(df_dates.dates, formats_dates)

# add 2000 years

df_dates.ISOdates[11:14] = df_dates.ISOdates[11:14] .+ Year(2000)

# query Dates

testdate = df_dates.ISOdates[1]

whichyear = Dates.Year(testdate)

whichmonth = Dates.Month(testdate)

whichyear = Dates.Day(testdate)

nameofmonth = Dates.monthname(testdate)

nameofmonthabbreviated = Dates.monthabbr(testdate)

dayofweekname = Dates.dayname(testdate)

dayofweeknameabbreviated = Dates.dayabbr(testdate)

# week starts on Monday

dayofweeknumber = dayofweek(testdate)


### TimeType == Time (nanoseconds)

df_times = DataFrame(CSV.File("tutorial_12/times.csv", delim='#', types=[String]))

# add index numbers

df_times.id = 1:nrow(df_times)

df_times = select!(df_times, :id, :)

formats_times = [
"HH:MM",
 "I:MMp",
 "I:MMp",
 "I:MM p",
 "I:MM p",
 "HH:MM",
 "I:MMp",
 "I:MMp",
 "I:MM p",
 "I:MM p"
 ]

 # parse String into Type Time

df_times.ISOtimes = Time.(df_times.times, formats_times)

# query times

testtime = df_times.ISOtimes[1]


whichhour = Dates.hour(testtime)

whichminute = Dates.minute(testtime)

whichsecond = Dates.second(testtime)
