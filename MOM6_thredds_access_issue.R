library(tidyverse)
library(glue)
library(ncdf4)

## full domain, all times, 1 depth ####
url="http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northeast_pacific/full_domain/hindcast/monthly/regrid/r20250912/vo_rotate.nep.full.hcast.monthly.regrid.r20250912.199301-202506.nc"
nc=nc_open(url)
z <- ncvar_get(nc, "z_l")
vo_surface <- ncvar_get(
  nc,
  varid = "vo_rotate",
  start = c(1, 1, 1, 1),
  count = c(-1, -1, 1, -1)
)

##---> fails
# Error in Rsx_nc4_get_vara_double: NetCDF: DAP failure
# Var: vo_rotate  Ndims: 4   Start: 0,0,0,0 Count: 390,1,815,341
# Error in ncvar_get_inner(ncid2use, varid2use, nc$var[[li]]$missval, addOffset,  : 
#                            C function R_nc4_get_vara_double returned error

## CCE domain, all times, 1 depth ####
lon  <- ncvar_get(nc, "lon")
lat  <- ncvar_get(nc, "lat")

# bounding box
lon_min <- 220
lon_max <- max(lon)
lat_min <- 20
lat_max <- 48

# indices
lon_idx <- which(lon >= lon_min & lon <= lon_max)
lat_idx <- which(lat >= lat_min & lat <= lat_max)

# counts
lon_start <- min(lon_idx)
lon_count <- length(lon_idx)

lat_start <- min(lat_idx)
lat_count <- length(lat_idx)

vo_surface_bbox <- ncvar_get(
  nc,
  varid = "vo_rotate",
  start = c(lon_start, lat_start, 1, 1),
  count = c(lon_count, lat_count, 1, -1)
)

##---> fails
# Error in Rsx_nc4_get_vara_double: NetCDF: DAP failure
# Var: vo_rotate  Ndims: 4   Start: 0,0,108,219 Count: 390,1,326,122
# Error in ncvar_get_inner(ncid2use, varid2use, nc$var[[li]]$missval, addOffset,  : 
#                            C function R_nc4_get_vara_double returned error

