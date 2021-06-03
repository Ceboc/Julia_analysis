# Tutorial 05: Statistics part 2 of 2

observations = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)

# 1. create linear regression manually using Plots/GR

using Plots
gr(size=(800,540))

p_line = plot(t,observations,
    xlabel = "Time",
    ylabel = "Observations",
    title = "Plots/GR Default (Line) Plot",
    legend = false
)

# create scatter plot

p_scatter = scatter(t,observations,
    xlabel = "Time",
    ylabel = "Observations",
    title = "Plots/GR Linear Regression",
    legend = false,
    color = :dodgerblue,
    alpha = 0.5
)

# calculate mean and standard deviation

using Statistics

avg = mean(observations)
stdev = std(observations)

# add menan and standard deviation to plot
hline!([avg - stdev, avg, avg + stdev],
    linestyle = :dash, color = :green
)

# generatr information needed to plot a linear regression linear
using GLM
using TypedTables

data = Table(X = t, Y = observations) # TypedTables


typeof(data)

# fit data into linear model

ols = lm(@formula(Y ~ X),data) # GLM

# add linear regression line to plot
plot!(t,predict(ols), color = :red, alpha = 0.5)

R² = r2(ols)

# how to use predict() function

predict(ols)

newX = Table(X = [5.5,10.7,12.3])

predict(ols,newX)

# don't extend prediction beyod observations

past_future_X = Table(X = [-100,100])

predict(ols,past_future_X)

# save plot

savefig(p_scatter,"tutorial_05/regression_gr.svg")

using StatsBase

# estimate number of bins

K = Int(round(1+3.322*log(length(observations)))) # Sturge's Rule

# fit data into Histogram
h = fit(Histogram,observations,nbins = K)

# generate Histogram
p_histogram = bar(h.edges, h.weights,
    xlabel = "Observations",
    ylabel = "Count",
    title = "Plots/GR Histogram",
    lengend = false,
    color = :dodgerblue,
    alpha = 0.5
)

# add mena and standard deviations

vline!([avg - stdev, avg, avg + stdev],
    linestyle = :dash, color = :green
)

# save plot
savefig(p_histogram,"tutorial_05/histogram_gr.svg")

using KernelDensity

d = kde(observations)

# generate plot 
p_density = plot(d.x, d.density,
    xlabel = "Observations",
    ylabel = "Density",
    title = "Plots/GR Density Plot",
    legend = false,
    fill = (0,:dodgerblue),
    alpha = 0.5
)

# add mena and standard deviations

vline!([avg - stdev, avg, avg + stdev],
    linestyle = :dash, color = :green
)


# backup calculations

density = d.density

bandwidth = step(d.x)

probability = density .* bandwidth

sum(probability)

# save plot
savefig(p_density,"tutorial_05/density_gr.svg")

# RESTART REPL

observations = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)

# select plottiong packages

using StatsPlots
plotlyjs(size = (800,450))

# 4. how to create linear regression using StatsPlots/plotlyjs

p_scatter = scatter(t,observations,
    xlabel = "Time",
    ylabel = "Observations",
    title = "StatsPlots/PlotlyJS Linear Regression",
    legend = false,
    color = :dodgerblue,
    alpha = 0.5,
    regression = true
)

# calculate mean and standard deviation
using Statistics

avg = mean(observations)
stdev = std(observations)

# add menan an standar deviation to plot
hline!([avg-stdev,avg,avg+stdev],
    linestyle = :dash,
    color = :green
)

# save plot
savefig(p_scatter,"tutorial_05/regression_plotlyjs.svg")

# 5. how to create histogram using StatsPlots/PlotlyJS

# Sturge's Rule
K = Int(round(1+ 3.322 * log(length(observations))))
# generate histogram 

p_histogram = histogram(observations,
    bins = K,
    xlabel = "Observations",
    ylabel = "Count",
    title = "StatsPlots/PlotlyJS Histogram",
    legend = false,
    color = :dodgerblue,
    alpha = 0.5
)

# add mean and standard deviations
vline!([avg-stdev,avg,avg+stdev],
    linestyle = :dash,
    color = :green
)

# save plot
savefig(p_histogram,"tutorial_05/histogram_plotlyjs.svg")


# 6. how to create density plot using StatsPlots/PlotlyJS

# generate plot

p_density = density(t,observations,
    xlabel = "Observations",
    ylabel = "Density",
    title = "StatsPlots/PlotlyJS Density Plot",
    legend = false,
    fill = (0, :dodgerblue),
    alpha = 0.5
)

# add mean and standard deviation

vline!([avg-stdev,avg,avg+stdev],
    linestyle = :dash,
    color = :green
)

# save plot
savefig(p_density,"tutorial_05/density_plotlyjs.svg")


# RESTART REPL

# USING CairoMakie

observations = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)

# select p´lotting package

using CairoMakie

# 7. how to create linear regression using CairoMakie

# select font(s)

font1 = "Comic Sans MS-Regular"
font2 = "Comic Sans MS-Bold"
font3 = "Comic Sans MS-Bold-Italic"
font4 = "Comic Sans MS-Italic"
font5 = "Times New Roman-Regular"

# initialize plot
fig  = Figure(resolution = (1280,720), font = font5)

ax1 = fig[1,1] = Axis(fig,
    title = "CairoMakie Linear Regression",
    xlabel = "Time",
    ylabel = "Observations"
)

fig

# generate scatter plot of data
scat1 = scatter!(ax1,t,observations,
    color = (:dodgerblue,0.5),merkersize = 12    
)
fig


# add mean and standard deviations
using Statistics

avg = mean(observations)
stdev = std(observations)

line1 = hlines!(ax1, [avg-stdev,avg,avg+stdev],
    color = :green, linewidth = 2, linestyle = :dash
)
fig

# add a linear regression line
using GLM
using TypedTables

data = Table(X=t,Y=observations) # TypedTables

ols = lm(@formula(Y~X),data) #GLM

line2 = lines!(ax1,t,predict(ols), color = (:red,0.5), linewidth = 3)
fig

# save plot

# 8. how to create histogram using CairoMakie

fig  = Figure(resolution = (1280,720), font = font5)

ax1 = fig[1,1] = Axis(fig,
    title = "CairoMakie Histogram",
    xlabel = "Observations",
    ylabel = "Count"    
)
fig

# Sturge's Rule

K = Int(round(1+ 3.322 * log(length(observations))))

# generate histogram 

hist1 = hist!(ax1, observations,
    color = (:dodgerblue, 0.5),
    strokecolor = :black, strokewidth = 1;
    bins = K
)
fig

line1 = vlines!(ax1, [avg-stdev,avg,avg+stdev],
    color = :green, linewidth = 2, linestyle = :dash
)
fig

# save plot
save("tutorial_05/histogram_cairomakie.svg",fig)

# 9. how to create density plot using CairoMakie
fig  = Figure(resolution = (1280,720), font = font5)

ax1 = fig[1,1] = Axis(fig,
    title = "CairoMakie Density Plot",
    xlabel = "Observations",
    ylabel = "Count"    
)
fig

# generate plot
den1 = density!(ax1, observations,
    color = (:dodgerblue,0.4),
    strokecolor = :black, strokewidth = 1
)
fig

# add menan and standard deviations
line1 = vlines!(ax1, [avg-stdev,avg,avg+stdev],
    color = :green, linewidth = 2, linestyle = :dash
)
fig

# save plot
save("tutorial_05/density_cairomakie.svg",fig)