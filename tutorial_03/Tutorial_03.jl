# Tutorial_03.jl

# Linear Examples

#  Example 1: From JuMPTutorials.jl
using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable(model, x >= 0)

@variable(model, y >= 0)

@constraint(model,6x + 8y >= 100)

@constraint(model,7x + 12y >= 120)

@objective(model,Min,12x + 20y)

optimize!(model)

@show value(x)

@show value(y)

@show objective_value(model)


# Optimization Workflow Template

# Describe Situation
# Select Packages
# Select Model
# Define Variables
# Define Constrains
# Set objective
# Run Solver
# Display Results
# Report Conclusion
# Visualize Conclusion (for nonlinear)


# Example 2: Knapsack Problem from Wikipedia (binary)

# Describe Situation

#=
    Pack the most valuable boxes without oberloading de luggage.
    Assume only 1 box of each color is available.
=#

#using JuMP
#using GLPK

# Select Model
model = Model(GLPK.Optimizer)

# Define Variables
@variable(model,green,Bin) # binary
@variable(model,blue,Bin)
@variable(model,orange,Bin)
@variable(model,yellow,Bin)
@variable(model,gray,Bin)

# Define Constrains
@constraint(model,weigth,
    green * 12 + blue * 2 + orange * 1 + yellow * 4 + gray * 1 <= 15
)

# Set objective
# given the weigth constraint, select the boxes that maximize 
# the dollar value
@objective(model, Max,
    green * 4 + blue * 2 + orange * 1 + yellow * 10 + gray * 2
)

# Run Solver
optimize!(model)

# Display Results

boxes = [green,blue,orange,yellow,gray]

for box in boxes
    println(box,"\t=",value(box))
end

value(weigth)

objective_value(model)

# Report Conclusion
#=
    A maximun dollar value of $ 15 can be arcieved by taking every box,
    except for the Green box, assuming there is only 1 box of each color.
=#


# Example 3: Knapsack Problem from Wikipedia (infinite supply)

# Describe Situation

#=
    Pack the most valuable boxes without oberloading de luggage.
    Assume an infinite supply of boxes box of each color is available.
=#

#using JuMP
#using GLPK

# Select Model
model = Model(GLPK.Optimizer)

# Define Variables
@variable(model,green >= 0, Int) # integer
@variable(model,blue >= 0, Int)
@variable(model,orange >= 0, Int)
@variable(model,yellow >= 0, Int)
@variable(model,gray >= 0, Int)

# Define Constrains
@constraint(model,weigth,
    green * 12 + blue * 2 + orange * 1 + yellow * 4 + gray * 1 <= 15
)

# Set objective
# given the weigth constraint, select the boxes that maximize 
# the dollar value
@objective(model, Max,
    green * 4 + blue * 2 + orange * 1 + yellow * 10 + gray * 2
)

# Run Solver
optimize!(model)

# Display Results

boxes = [green,blue,orange,yellow,gray]

for box in boxes
    println(box,"\t=",value(box))
end

value(weigth)

objective_value(model)

# Report Conclusion
#=
    A maximun dollar value of $ 36 can be arcieved by taking 3 Yellow boxes
    and 3 Gray boxes, assuming an infinite supply of boxes of each color.
=#


########################################################################################

# Nonlinear Examples

# Example 4: Maximize area of yard

# Describe Situation
#=
    Given 100 feet of total fencing material, enclose a rectangular yard along a stone wall,
    using 3 sides of fencing, that maximizes the area of that yard.
=#

# Select Packages

# using JuMP
using Ipopt

# Select Model
model = Model(Ipopt.Optimizer)

# Define Variables
@variable(model,x>=0,start = 0)
@variable(model,y>=0,start = 0)

# Define Constrains
@NLconstraint(model,x+2y==100)

# Set objective
@NLobjective(model,Max,x*y)

# Run Solver
optimize!(model)

# Display Results
value(x)
value(y)
objective_value(model)

# Report Conclusion
#=
    The Maximmum area is 1250 square feet, which is achieved by having
    the 2 side fences equal to 25 feet each an the third side equal 50 feet.
=#

# Visualize Conclusion (for nonlinear)

# select  Frontend and Backend

using Plots
plotlyjs(size = (760,760))

# select variable range for the x-axis

x = 0:100

# select variable function to plot along y-axis
area(x) = x*(100-x)/2

# generate plot
p = plot(x,area,
    title = "Maximize Area",
    xlabel = "Length of x (feet)",
    ylabel = "Area (square feet)"
)

# save plot
savefig(p,"tutorial_03/max_area.svg")



# Example 5: Minimize Travel Time

# Describe Situation
#=
    There is a rece that involves running East on the beach and swimming
    North to an island. Measunring along the beach, a racer would have to
    run 6 miles to be directly South of the island. The island is 2 miles
    North of that point on the beach. The racer can run at 8 mph and can
    swim at 3 mph. The racer can enter the water at any point on the beach
    to begin swimming to the island. At what point should the recer enter
    the water in order to Minimize the total travel time to the island?
=#

# Select Packages
# using JuMP
# using Ipopt


# Select Model
model = Model(Ipopt.Optimizer)

# Define Variables
@variable(model, 0<=x<=6, start = 0)

# Define Constrains

# Set objective
@NLobjective(model,Min,x/8 + sqrt((6-x)^2+2^2)/3)

# Run Solver
optimize!(model)

# Display Results
value(x)
objective_value(model)

# Report Conclusion
#=
    The minimum time it would take a racer to reach the island is
    1.37 hours, which can be achieved by running 5.19 miles along
    the beach before entering the water to swim to the island
=#


# Visualize Conclusion (for nonlinear)

# select Frontend and Backend
# using Plots
# plotlyjs(size=(760,570))

# select variable range for the x-axis

x = 0:0.01:6

# select objective function to plot along y-axis
time(x) = x/8 + sqrt((6-x)^2+2^2)/3

# generate plot

p = plot(x, time,
        title = "Minimize Travel time",
        xlabel = "Distance (miles)",
        ylabel = "Time (hours)"

)

# save plot
savefig(p,"tutorial_03/min_time.svg")




# Example 6: Maximize Revenue

# Describe Situation
#=
    A car rental company charges anywhere from $50 per day to $200
    per day. The Demand Curve for their cairs is Q(P) = 1000 - 5P.
    What price should they charge in order to Maximize their Revenue?
=#

# Select Packages
#using JuMP
#using Ipopt

# Select Model
model = Model(Ipopt.Optimizer)

# Define Variables
@variable(model,50 <= P <= 200, start = 50)

# Define Constrains


# Set objective
@NLobjective(model,Max,P*(1000-5P)) # Revenue = P*Q

# Run Solver
optimize!(model)

# Display Results
value(P)
objective_value(model)

# Report Conclusion
#= 
    A Maximum Revenuie of $50,000 per day can be achieved by setting
    the rental price to $100 per day
=#

# Visualize Conclusion (for nonlinear)
# select Frontend and Backend
# using Plots
# plotlyjs(size=(760,570))

# select variable range for the x-axis

P = 50:0.01:200

# select objective function to plot along y-axis
revenue(P) = P*(1000-5P)

# generate plot

p = plot(P, revenue,
        title = "Maximize Revenue",
        xlabel = "Price (dollars)",
        ylabel = "Revenue (dollars)"

)

savefig(p,"tutorial_03/max_revenue.svg")

# Plot Demand Curve
Q(P) = 1000 -5P

# generate plot
p = plot(P,Q,
    title = "Demand Curve",
    xlabel = "Price (dollars)",
    ylabel = "Quantity (cars)"
)

# save plot
savefig(p,"tutorial_03/demand_cruve.svg")