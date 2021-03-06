# Tutorial 09

# VegaLite

using VegaLite, VegaDatasets

# load JSON file containing map of using

us10m = dataset("us-10m")

# 1. US Map by state 

# how to generate a plot

p = @vlplot(
    width = 640,
    height = 360,
    title = "US Map by State",
    projection = {type = :albersUsa},
    data = {
        values = us10m,
        format = {
            type = :topojson,
            feature = :states
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

# how to save plot
save("tutorial_09/p_us_states.svg",p)


# 2. Map of single US State 
# sparate plot into layers
# canvas

canvas = @vlplot(
    width = 640,
    height = 360,
    projection = {type = :albersUsa},
    title = "Map of Alaska"
)

# map of single state
st_map = @vlplot(
    data = {
        values = us10m,
        format = {
            type = :topojson,
            feature = :states
        }
    },
    transform = [{
        filter = {
            field = :id,
            equal = 2
        }
    }
    ],
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

# combine layers 
p = canvas + st_map

# save plot
save("tutorial_09/p_alaska.svg",p)

# 3. US Map by State with State Capitals (from documentation)

# load JSON file containing locations of state Capitals

capitals = dataset("us-state-capitals")

vscodedisplay(capitals)

# canvas

canvas = @vlplot(
    width = 640,
    height = 320,
    title = "US State Capitals",
    projection = {type = :albersUsa}
)

# map of us

usmap = @vlplot(
    data = {
        values = us10m,
        format = {
            type = :topojson,
            feature = :states
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

# location marjes for state capitals
capitalmap = @vlplot(
    data  = capitals,
    mark = :circle,
    latitude = "lat:q",
    longitude = "lon:q",
    color = {value = :red}
)

# names of state capitals
capitalnames = @vlplot(
    data = capitals,
    mark = {
        type = :text,
        dy = 8,
        fontSize = 6
    },
    latitude = "lat:q",
    longitude = "lon:q",
    text = "city:n"
)

# combine layesrs

p = canvas + usmap + capitalmap + capitalnames

# saveplot
save("tutorial_09/p_us_capitals.svg",p)


# 2. US Map by County 

p = @vlplot(
    width = 640,
    height = 360,
    title = "US Map by County",
    projection = {type = :albersUsa},
    data = {
        values = us10m,
        format = {
            type = :topojson,
            feature = :counties
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)
# save plot
save("tutorial_09/p_us_counties.svg",p)


# 5. Choropleth Map of US Unemployment Rate by County (from documentation)

# load unemployment by county (year unknown)

unemployment = dataset("unemployment")

vscodedisplay(unemployment)

# canvas
canvas = @vlplot(
    width = 640,
    heigth = 360,
    title = "US Unemployment Rate by County (year unknown)",
    projection = {type = :albersUsa}
)

# map of us
usmap = @vlplot(
    data = {
        values = us10m,
        format = {
            type = :topojson,
            feature = :counties
        }
    },
    transform = [{
        lookup = :id,
        from = {
            data = unemployment,
            key = :id,
            fields = ["rate"]
        }
    }],
    mark = :geoshape,
    color = "rate:q"
)

p = canvas + usmap

# saveplot
save("tutorial_09/ps_us_unemployment.svg",p)


# 6. World Map by country
# load JSON file containing map of World

world110m = dataset("world-110m")

# canvas 

canvas = @vlplot(
    width = 640,
    height = 360,
    title = "World Map by Country",
    projection = {type = :equalEarth}
)

# world map
worldmap = @vlplot(
    data = {
        values = world110m,
        format = {
            type = :topojson,
            feature = :countries
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

# combine layers 
p = canvas + worldmap

# save plot
save("tutorial_09/p_world_countries.svg",p)


# 7. Single Country Map

# canvas

canvas = @vlplot(
    width = 640,
    height = 360,
    title = "Mapa do Brasil",
    projection = {type = :mercator}
)

# country map

countrymap = @vlplot(
    data = {
        values = world110m,
        format = {
            type = :topojson,
            feature = :countries
        }
    },
    transform = [{
        filter = {
            field = :id,
            equal = 76
        }
    }],
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

# combine layers
p = canvas + countrymap

# save plot
save("tutorial_09/p_brasil.svg",p)


# 8. Choropleth Map of 2019 Population by Country
# load population data by country code

using DataFrames, CSV

df_countrycode = DataFrame(CSV.File("tutorial_09/df_countrycode.csv"))

vscodedisplay(df_countrycode)


# rotation settings
west = [35,-15,-2.5]
east = [-70,-12.5,-7]

# canvas
# canvas

canvas = @vlplot(
    width = 640,
    height = 360,
    title = "2019 Population by Country",
    projection = {
        type = :orthographic,
        rotate = east
    }
)

# world map

worldmap = @vlplot(
    data = {
        values = world110m,
        format = {
            type = :topojson,
            feature = :countries
        }
    },
    transform = [{
        lookup = :id,
        from = {
            data = df_countrycode,
            key = :id,
            fields = ["my19"]
        }
    }],
    mark = :geoshape,
    color = "my19:q"
)

# combine layers
p = canvas + worldmap

# save plot
save("tutorial_09/p_population_east.svg",p)

# 9. Choropleth Map of GDP per Capita by Country

canvas = @vlplot(
    width = 640,
    height = 360,
    title = "2019 GDP per Capita by Country",
    projection = {
        type = :orthographic,
        rotate = west
    }
)

# world map

worldmap = @vlplot(
    data = {
        values = world110m,
        format = {
            type = :topojson,
            feature = :countries
        }
    },
    transform = [{
        lookup = :id,
        from = {
            data = df_countrycode,
            key = :id,
            fields = ["gdppc"]
        }
    }],
    mark = :geoshape,
    color = "gdppc:q"
)

# combine layers
p = canvas + worldmap

# save plot
save("tutorial_09/p_gdppc_west.svg",p)


# 10. Choropleth Map of 2019 Population Growth Rate by Country
canvas = @vlplot(
    width = 640,
    height = 360,
    title = "2019 Population Growth by Country",
    projection = {
        type = :orthographic,
        rotate = east
    }
)

# world map

worldmap = @vlplot(
    data = {
        values = world110m,
        format = {
            type = :topojson,
            feature = :countries
        }
    },
    transform = [{
        lookup = :id,
        from = {
            data = df_countrycode,
            key = :id,
            fields = ["mypct"]
        }
    }],
    mark = :geoshape,
    color = "mypct:q"
)

# combine layers
p = canvas + worldmap

# save plot
save("tutorial_09/p_growth_east.svg",p)