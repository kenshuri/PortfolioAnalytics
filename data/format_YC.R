# Création des variables contenant tous les taux US
# Source des données : https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield

# Chargement des librairies nécessaires
library(data.table)
library(XML)
library(xts)

# Lecture du fichier
doc <- xmlParse("data/DailyTreasuryYieldCurveRateData_ALL")
df <- xmlToDataFrame(nodes = getNodeSet(doc, "//m:properties"))
dt <- as.data.table(df)
# A ce stade, les types des colonnes ne sont pas les bons, il faut donc les modifier

# Supression de la dernière colonne
dt <- dt[,-c("BC_30YEARDISPLAY")]

# Construction du data_table de dates
dt_date <- data.table(dt[, as.Date(NEW_DATE)])

# Construction du data table de taux
dt_yield <-
  data.table(sapply(as.data.table(sapply(dt[,-c("Id", "NEW_DATE")], as.character)), as.double))

# Construction des variables finales
dt <- cbind.data.frame(dt_date, dt_yield)
data_xts <- as.xts(dt)

## Outliers management
# Linear Approximation
# data_xts["20170414",] <- rep(NA,12)
# data_xts["20170414",]<- na.approx(data_xts["20170410/20170417"])["20170414"]
# Occurence deleting
data_xts <- data_xts[-c(data_xts["2017-04-14",which.i=TRUE])]


# After a short study on the performance of fwrite vs zoo.write , we use the fwrite function to store data. 
# Therefore, we transform back our xts object in a data.table.
# write.zoo(data_xts,file="data/data_YC_US")
data_dt <- as.data.table(data_xts)
fwrite(data_dt,"data/data_YC_US")

# # Import the data from the newly created file
# dat_zoo <- read.zoo("data/data_US",index.column = 1, header = TRUE)
# dat_xts <- as.xts(dat_zoo)

# # Plot the data
# plot(dat_xts)

# # Vérification de la bonne importation en utilisant plusieurs fichiers d'input différents
# # Lecture des fichiers
# name_prefixe <- "data/DailyTreasuryYieldCurveRateData_"
# name_suffixe <- sapply(2014:2020,as.character)
# names <- data.table(name_prefixe,name_suffixe)
# names[,name:=paste0(name_prefixe,name_suffixe)]
# dt_comp <- data.table()
# for (name in names[,name]){
#   doc <- xmlParse(name)
#   df_aux <- xmlToDataFrame(nodes = getNodeSet(doc, "//m:properties"))
#   dt_aux <- as.data.table(df_aux)
#   # A ce stade, les types des colonnes ne sont pas les bons, il faut donc les modifier
#
#   # Teste si les deux dernières colonnes sont identiques
#   stopifnot(sum(dt_aux[BC_30YEARDISPLAY!=0,as.numeric(BC_30YEAR!=BC_30YEARDISPLAY)])==0)
#   # Supression de la dernière colonne
#   dt_aux <- dt_aux[,-c("BC_30YEARDISPLAY")]
#
#   # Construction du data_table de dates
#   dt_date <- data.table(dt_aux[,as.Date(NEW_DATE)])
#
#   # Construction de la matrice de taux
#   dt_yield <- data.table(sapply(as.data.table(sapply(dt_aux[,-c("Id","NEW_DATE")],as.character)),as.double))
#
#   # Construction du data_table avec les bons types
#   dt_aux <- cbind.data.frame(dt_date,dt_yield)
#
#   # Chaînage avec le data table général
#   dt_comp <- rbind.data.frame(dt_comp,dt_aux)
# }
#
# data_comp_xts <- as.xts(dt_comp)
#
# data_part_xts <- data_xts["2014/"]
# stopifnot(sum(as.numeric(data_comp_xts != data_part_xts),na.rm = TRUE)==0)