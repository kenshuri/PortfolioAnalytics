# Creating the CSV file containing all LIBOR data
# Source data available here : https://fred.stlouisfed.org/categories/33003?t=usa&ob=pv&od=desc

library(data.table)
library(xts)

# First step is to read the data from the several imported files
tenors <- c("ON","1M","3M","6M","12M")
libor_dt <- data.table()

for (tenor in tenors){
  dt_aux <- fread(paste("data/USD",tenor,"TD156N.csv",sep=""))
  # Set the good type to both columns
  dt_aux[,Date := as.Date(DATE)]
  dt_aux[,Tenor := tenor]
  dt_aux[,Value := sapply(dt_aux[,2],as.double)]
  dt_aux[,1:=NULL]
  dt_aux[,1:=NULL]
  libor_dt<-rbind(libor_dt,dt_aux)
}

# Transform the data.table from a long formal to a wide format
libor_dt_dcast <- dcast(libor_dt,Date ~Tenor, value.var = "Value")
setcolorder(libor_dt_dcast, c("Date",tenors))
libor_xts <- as.xts(libor_dt_dcast)

# Creating the formated file
# After a short study on the performance of fwrite vs zoo.write , we use the fwrite function to store data. 
# Therefore, we transform back our xts object in a data.table.
# write.zoo(libor_xts,file="data/data_LIBOR_US")
libor_dt <- as.data.table(libor_xts)
fwrite(libor_dt,"data/data_LIBOR_US")

