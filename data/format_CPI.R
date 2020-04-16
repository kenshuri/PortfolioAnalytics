# Création de la variable contenant tous les CPI US
# Source des données https://data.bls.gov/pdq/SurveyOutputServlet

library(data.table)

# Récupération des données
cpi_dt <- fread("data/CPI_US.csv")

# Mise en forme des données
cpi_dt[,Date:=as.Date(Date,"%d/%m/%Y")]
cpi_dt[,CPI:=as.numeric(sub(",", ".", cpi_dt[,Value], fixed = TRUE))][,Value:=NULL]
cpi_dt[, infl_rate := shift(CPI,1)/CPI - 1 ]
cpi_xts <- as.xts(cpi_dt)

# Création du fichier formaté
# After a short study on the performance of fwrite vs zoo.write , we use the fwrite function to store data. 
# Therefore, we transform back our xts object in a data.table.
cpi_dt <- as.data.table(cpi_xts)
fwrite(cpi_dt,file="data/data_CPI_US")