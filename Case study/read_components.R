  library(tidyverse)
 
#read data using read.delim and the separators 
#K1
  
K1be1 <-  read.delim(paste("Data/Komponente/Komponente_K1BE1.csv",sep = ""), head = TRUE,",")
K1be2 <-  read.delim(paste("Data/Komponente/Komponente_K1BE2.csv",sep = ""), head = TRUE, ";")
K1di1 <-  read.delim(paste("Data/Komponente/Komponente_K1DI1.csv",sep = ""), head = TRUE, ",")
  
  
#K2
K2le2 <-  read.delim(paste("Data/Komponente/Komponente_K2LE2.txt",sep = ""), header = TRUE, "\\")
K2st1 <-  read.delim(paste("Data/Komponente/Komponente_K2ST1.txt",sep = ""), header = TRUE, sep = "|")
K2st2 <-  read.delim(paste("Data/Komponente/Komponente_K2ST2.csv",sep = ""), header = TRUE, sep = ";")

#K3

k3ag1 <-  read.delim(paste("Data/Komponente/Komponente_K3AG1.csv",sep = ""), header = TRUE, ",")
k3ag2 <-  read.delim(paste("Data/Komponente/Komponente_K3AG2.txt", sep = ""), header = TRUE, "\\")
k3sg1 <-  read.delim(paste("Data/Komponente/Komponente_K3SG1.csv",sep = ""), header = TRUE, ",")
k3sg2 <-  read.delim(paste("Data/Komponente/Komponente_K3SG2.csv",sep = ""), header = TRUE, ",")

#K4 -k7

k4 <-  read.delim(paste("Data/Komponente/Komponente_K4.csv", sep = ""), header = TRUE, ";")
k5 <-  read.delim(paste("Data/Komponente/Komponente_K5.csv", sep = ""), header = TRUE, ",")
k6 <-  read.delim(paste("Data/Komponente/Komponente_K6.csv", sep = ""), header = TRUE, ";")
k7 <-  read.delim(paste("Data/Komponente/Komponente_K7.txt", sep = ""), header = TRUE, "\t")
