using DataFrames: DataAPI, propertynames, length
# tutorial 11

# ANIMATION

# Animate population by year

# load data

using DataFrames, CSV

df = DataFrame(CSV.File("tutorial_11/population_by_year.csv"))

vscodedisplay(df)

regions = propertynames(df)[2:end]

# initialize plot
using GLMakie

fig = Figure(resolution=(1920, 1080))

ax1 = fig[1,1] = Axis(fig,
    # title
    title="Black = World | Magenta = Asia | Red = Africa | Yellow = Europe
Green = L_America | Cyan = N_America | Blue = Oceania",
    titlegap=24, titlesize=24,
    # x-axis
    xgridcolor=:darkgray, xgridwidth=2,
    xlabel="Year" , xlabelsize=24,
    xticklabelsize=18, xticks=LinearTicks(20),
    # y-axis
    ygridcolor=:darkgray, ygridwidth=2,
    ylabel="Population in Millions",
    ylabelsize=24, ytickformat="{:d}",
    yticklabelsize=18, yticks=LinearTicks(10)
)

# prep for recording

frames = 1:(length(df.Year))

colors = [:black, :red, :magenta, :yellow, :green, :cyan, :blue]

# record ANIMATION

record(fig, "tutorial_11/a_population_by_region.mp4", frames; framerate=12) do i 
    for j in 1:length(regions)
        lines!(ax1, df[1:i,1],df[1:i,(j + 1)],
            color=(colors[j], 0.5), linestyle=:dash, linewidth=2
        )
        scatter!(ax1, df[1:i,1],df[1:i,(j + 1)],
            color=colors[j],markersize=9
        )
    end
end


# animate π estimation

# initialize plot

fig = Figure(resolution=(1920, 1080))

# add axis for dartboard

ax1  = fig[1,1] = Axis(fig,
    # borders
    aspect=1, targetlimits=BBox(-1, 1, -1, 1),
    # title
    title="Dartboard",
    titlegap=24, titlesize=30,
    # xaxis
    xautolimitmargin=(0, 0), xgridcolot=:black, xgridwidth=2,
    xticklabelsize=18, xticks=LinearTicks(11), xticksize=9,
    # y-axis
    yautolimitmargin=(0, 0), ygridcolor=:black, ygridwidth=2,
    yticklabelsize=18, yticks=LinearTicks(11), yticksize=9
)

# add axis for pi estimate

ax2 = fig[1,2] = Axis(fig,
    # borders
    width=700,
    # title
    title="pi Estimate",
    titlegap=24, titlesize=30,
    # x-axis
    xautolimitmargin=(0, 0), xgridwidth=2,
    xticklabelsize=18, xticks=LinearTicks(5), xticksize=9,
    # y-axis
    yautolimitmargin=(0, 0), ygridwidth=2,
    yticklabelsize=18, yticks=LinearTicks(10), yticksize=9
)

# refine layout

sublayout = GridLayout(width=37.5)

fig[1,3] = sublayout

# add target for pi
hlines!(ax2,[pi],linewidth=5, color=:green)

# generate random data

using Random

Random.seed!(31416)

n = 144_000


x = [rand() * rand((-1, 1)) for _ in 1:n]

vscodedisplay(x)

y = [rand() * rand((-1, 1)) for _ in 1:n]

vscodedisplay(y)

circle = [x[i]^2 + y[i]^2 <= 1 for i in 1:n]

vscodedisplay(circle)

circle_sum = Int64[]

push!(circle_sum,circle[1])

for i in 1:(n - 1)
    new_sum = circle_sum[i] + circle[i + 1]
    push!(circle_sum, new_sum)
end

vscodedisplay(circle_sum)

circle_sum[end]

sum(circle)

pi_est = [4 * circle_sum[i] / i for i in 1:n]

vscodedisplay(pi_est)

pi_est[end]

(pi - pi_est[end]) / pi * 100

# prep for recording

colors = Symbol[]

for i in 1:length(circle)
    circle[i] ? c = :green : c = :red
push!(colors, c)
end

vscodedisplay(colors)

index = 1:n

frames = 1:720

# record animation

record(fig, "tutorial_11/a_pi_est.mp4", frames; framerate=24) do i
    # create plotting range
    stop = i * 200
    start = stop - 199
    range = start:stop
    # add plot for dartboard
    scatter!(ax1,
        x[range], y[range], color=colors[range], markersize=5
    )
    # add plot for pi estimate
    scatter!(ax2,
        index[range], pi_est[range], color=:blue, markersize=5
    )
end

