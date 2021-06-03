# Tutorial 01: Iris Dataset

# Julia 1.6.1

# Packages versions on Manifest.toml
using VegaDatasets
using DataVoyager
using VegaLite

# Load Dataset
data = dataset("Iris")

# Display dataset
vscodedisplay(data) #only valid on vscodedisplay

# Visualize dataset
v = Voyager(data)

# Specify plot in DataVoyager before proceeding
# assing specified plot to a variable

p = v[]

# save plot
save("tutorial_01/iris_vogager.png",p)
save("tutorial_01/iris_vogager.svg",p)