# Load libraries
library(xts)
library(data.table)
library(microbenchmark)
library(fasttime)

yc_dt <- fread("data/data_YC_US")
yc_dt[,index:=fastPOSIXct(index)]
yc_dt[,index:=as.Date(index)]
yc_xts <- as.xts(yc_dt)

cpi_dt <- fread("data/data_CPI_US")
cpi_dt[,index:=fastPOSIXct(index)]
cpi_dt[,index:=as.Date(index)]
cpi_xts <- as.xts(cpi_dt)

libor_dt <- fread("data/data_LIBOR_US")
libor_dt[,index:=fastPOSIXct(index)]
libor_dt[,index:=as.Date(index)]
libor_xts <- as.xts(libor_dt)