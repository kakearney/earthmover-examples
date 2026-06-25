# Lazily load the entire dataset
library(ncdfCF)
url <- "https://compute.earthmover.io/v1/services/dap2/NOAA-PMEL/cefi-nep-hindcast-monthly/main/regrid/main/opendap"
ds <- open_ncdf(url)

# look at the variables
names(ds)

# Lazy load
vo <- ds[["vo_rotate"]]

# Let's check dimnames
dimnames(vo)

# Let's get surface for one time-step
# Takes about 1.6 seconds for me, so 10 min for the whole thing and 0.9 Gb
system.time({
  vo_surface_t1 <- vo[, , 1, 1]
})

## Try a smaller area
lon_axis <- ds[["lon"]]
lat_axis <- ds[["lat"]]

lon <- lon_axis$coordinates
lat <- lat_axis$coordinates

## Bounding box
lon_min <- 220
lon_max <- max(lon)
lat_min <- 20
lat_max <- 48

##
# https://r-cf.github.io/ncdfCF/articles/ncdfCF.html
(vo_sub <- vo$subset(z_l = 2.5, 
                     lon = c(lon_min, lon_max), 
                     lat = c(lat_min, lat_max),
                     time = 2025))


## this works
lon <- ds[["lon"]]$coordinates
lat <- ds[["lat"]]$coordinates

lon_idx <- which(lon >= lon_min & lon <= lon_max)
lat_idx <- which(lat >= lat_min & lat <= lat_max)

vo_surface_bbox <- vo[lon_idx, lat_idx, 1, ]
