library(terra)
library(dplyr)
library(rgeoda)
library(geodata)
library(viridisLite)

# load in built volume layer processed from An. stephensi
built_volume <- rast("data/MAP_covariates/GHS_BUILT_V_R23A.2020.Annual.Data.1km.Data.tif")

# get vector outline of Nigeria
nigeria_vector <- gadm(
  country = "NGA",
  level = 0,
  path = "data/downloads"
)

nigeria_vector

plot(nigeria_vector)

# mask and crop built volume to area of interest (Nigeria)
built_nigeria <- mask(
  x = built_volume,
  mask = nigeria_vector
) %>%
  crop(
    y = nigeria_vector
  )


writeRaster(
  x = built_nigeria,
  filename = "output/grids/built_nigeria.tif"
)

plot(built_nigeria)


# extract data from built volume for nigeria and compute break points
# using Jenks clustering for natural breaks for three and six classes

built_nigeria_vector <- as.vector(built_nigeria)^(1/3) 

built_nigeria_vector_no_na <- built_nigeria_vector[!is.na(built_nigeria_vector)]

built_nigeria_df <- data.frame(vol = built_nigeria_vector_no_na)

breaks_nigera_3 <- natural_breaks(
  k = 3,
  df = built_nigeria_df["vol"]
)

breaks_nigera_6 <- natural_breaks(
  k = 6,
  df = built_nigeria_df["vol"]
)

# create classes from these break points

# class names
# names3 <- c(
#   "rural",
#   "peri-urban",
#   "urban"
# )
# 
# names6 <- c(
#   "rural",
#   "semi-rural",
#   "rural-peri-urban",
#   "peri-urban",
#   "urban",
#   "dense-urban"
# )

names3 <- 1:3

names6 <- 1:6


bnv3 <- case_when(
  built_nigeria_vector < breaks_nigera_3[1] ~ names3[1],
  built_nigeria_vector < breaks_nigera_3[2] ~ names3[2],
  built_nigeria_vector >= breaks_nigera_3[2] ~ names3[3],
  TRUE ~ NA
) %>%
  factor(
    levels = names3
  )

bnv6 <- case_when(
  built_nigeria_vector < breaks_nigera_6[1] ~ names6[1],
  built_nigeria_vector < breaks_nigera_6[2] ~ names6[2],
  built_nigeria_vector < breaks_nigera_6[3] ~ names6[3],
  built_nigeria_vector < breaks_nigera_6[4] ~ names6[4],
  built_nigeria_vector < breaks_nigera_6[5] ~ names6[5],
  built_nigeria_vector >= breaks_nigera_6[5] ~ names6[6],
  TRUE ~ NA
) %>%
  factor(
    levels = names6
  )

built_nigeria_3 <- built_nigeria
built_nigeria_6 <- built_nigeria

built_nigeria_3[] <- bnv3 
built_nigeria_6[] <- bnv6

levels3 <- data.frame(
  id = 1:3,
  urban_class = names3
)

levels6 <- data.frame(
  id = 1:6,
  urban_class = names6
)

levels(built_nigeria_3) <- levels3
levels(built_nigeria_6) <- levels6


# save rasters to disc
writeRaster(
  x = built_nigeria_3,
  filename = "output/grids/urban_nigeria_3.tif",
  overwrite = TRUE
)

writeRaster(
  x = built_nigeria_6,
  filename = "output/grids/urban_nigeria_6.tif",
  overwrite = TRUE
)


# plot them

plot(
  built_nigeria_3,
  col = mako(
    n = 3,
    direction = -1
  )
)

plot(
  built_nigeria_6,
  col = mako(
    n = 6,
    direction = -1
  )
)

lagos_area <-  c(
  2.91081917173319,
  4,
  6.3,
  7.3
) %>%
  ext

plot(
  built_nigeria_3,
  ext = lagos_area,
  col = mako(
    n = 3,
    direction = -1
  )
)


plot(
  built_nigeria_6,
  ext = lagos_area,
  col = mako(
    n = 6,
    direction = -1
  )
)

# save figures
png(
  filename = "output/figures/urban_nigeria_3.png",
  width = 3600,
  height = 2000,
  res = 300
)

plot(
  built_nigeria_3,
  col = mako(
    n = 3,
    direction = -1
  )
)

dev.off()

png(
  filename = "output/figures/urban_nigeria_6.png",
  width = 3600,
  height = 2000,
  res = 300
)

plot(
  built_nigeria_6,
  col = mako(
    n = 6,
    direction = -1
  )
)

dev.off()


png(
  filename = "output/figures/urban_lagos_3.png",
  width = 3600,
  height = 2000,
  res = 300
)
plot(
  built_nigeria_3,
  ext = lagos_area,
  col = mako(
    n = 3,
    direction = -1
  )
)
dev.off()


png(
  filename = "output/figures/urban_lagos_6.png",
  width = 3600,
  height = 2000,
  res = 300
)
plot(
  built_nigeria_6,
  ext = lagos_area,
  col = mako(
    n = 6,
    direction = -1
  )
)
dev.off()