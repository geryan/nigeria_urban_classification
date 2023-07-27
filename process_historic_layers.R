library(terra)
library(dplyr)
library(geodata)
library(viridisLite)
library(tidyterra)
library(RColorBrewer)
# get internal state boundaries
nigeria_states <- gadm(
  country = "NGA",
  level = 1,
  path = "data/downloads"
)

nigeria_states

plot(nigeria_states)

kwara_vector <- nigeria_states %>%
  filter(NAME_1 == "Kwara")

an_ratios <- rast("data/rasters/ara_fun_gam_masked.tif")
irs_ratios <- rast("data/rasters/IRS_ratios.tif")
itn_ratios <- rast("data/rasters/IRS_ratios.tif")
names(an_ratios) <- c("An. arabiensis", "An. funestus", "An gambiae")
names(irs_ratios) <- names(an_ratios)
names(itn_ratios) <- names(an_ratios)

plot(
  an_ratios,
  col = mako(
    n = 2048,
    direction = -1
  )
)

plot(
  irs_ratios,
  col = mako(
    n = 2048,
    direction = -1
  )
)

plot(
  itn_ratios,
  col = mako(
    n = 2048,
    direction = -1
  )
)

irs_change <- an_ratios - irs_ratios
itn_change <- an_ratios - itn_ratios


plot(
  irs_change,
  col = brewer.pal(
    n = 11,
    name = "PRGn"
  ),
  range = c(-1, 1)
)

plot(
  itn_change,
  col = brewer.pal(
    n = 11,
    name = "PRGn"
  ),
  range = c(-1, 1)
)


ir_2017 <- rast("data/rasters/predicted resistance 2017/IR rasters 2017.grd")

plot(
  ir_2017,
  col = mako(
    n = 2048
  ),
  range = c(0,1)
)




built_kwara_3 <- mask(
  x = built_nigeria_3,
  mask = kwara_vector
) %>%
  crop(
    y = kwara_vector
  )

# 
# an_ratios_reproj <- project(
#   x = an_ratios,
#   y = crs(built_kwara_3)
# )
# 
# built_kwara_3_resample <- resample(
#   x = built_kwara_3,
#   y = an_ratios_reproj,
#   method = "near"
# )


an_ratios_kwara <- an_ratios%>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

irs_ratios_kwara <- irs_ratios %>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

irs_change_kwara <- irs_change %>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

itn_ratios_kwara <- itn_ratios %>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

itn_change_kwara <- itn_change %>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

ir_2017_kwara <- ir_2017 %>%
  mask(kwara_vector) %>%
  crop(kwara_vector)

writeRaster(
  an_ratios_kwara,
  "output/grids/an_ratios_kwara.tif",
  overwrite = TRUE
)

writeRaster(
  irs_ratios_kwara,
  "output/grids/irs_ratios_kwara.tif",
  overwrite = TRUE
)

writeRaster(
  irs_change_kwara,
  "output/grids/irs_change_kwara.tif",
  overwrite = TRUE
)

writeRaster(
  itn_ratios_kwara,
  "output/grids/itn_ratios_kwara.tif",
  overwrite = TRUE
)

writeRaster(
  itn_change_kwara,
  "output/grids/itn_change_kwara.tif",
  overwrite = TRUE
)

writeRaster(
  ir_2017_kwara,
  "output/grids/ir_2017_kwara.tif",
  overwrite = TRUE
)





