library(tidyverse)
 
#read data using read.delim and the separators 
#K1
  
k1be1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1BE1.csv",sep = ""), head = TRUE, ","))#ok
k1be2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1BE2.csv",sep = ""), head = TRUE, ";"))#ok
k1di1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1DI1.csv",sep = ""), head = TRUE, ","))#ok
#K1di2 
k1di2 <- readChar('Data/Komponente/Komponente_K1DI2.txt', file.info('Data/Komponente/Komponente_K1DI2.txt')$size)
k1di2 <- gsub('[[:blank:]]', '\\', k1di2)
k1di2 <- gsub('""', '"\n"', k1di2)

k1di2 <- tidy_dataset(read.delim(text = k1di2, header = TRUE , sep = '\\'))

  
  
#K2
k2le2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2LE2.txt",sep = ""), header = TRUE, "\\"))#ok
k2st1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2ST1.txt",sep = ""), header = TRUE, "|"))#ok
k2st2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2ST2.csv",sep = ""), header = TRUE, ";"))#ok
#K2le1

K2le1 <- readChar('Data/Komponente/Komponente_K2LE1.txt', file.info('Data/Komponente/Komponente_K2LE1.txt')$size)
K2le1 <- gsub('\x0B"', '\n"', K2le1)
K2le1 <- gsub('II', ' ', K2le1)
K2le1 <- tidy_dataset(read.delim(text = K2le1, header = TRUE , sep = ' '))

#K3

k3ag1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3AG1.csv",sep = ""), header = TRUE, ","))#ok
k3ag2 <- tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3AG2.txt", sep = ""), header = TRUE, "\\"))#ok
k3sg1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3SG1.csv",sep = ""), header = TRUE, ","))#ok
k3sg2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3SG2.csv",sep = ""), header = TRUE, ","))#ok

#K4 -k7

k4 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K4.csv", sep = ""), header = TRUE, ";"))#ok
k5 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K5.csv", sep = ""), header = TRUE, ","))#ok
k6 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K6.csv", sep = ""), header = TRUE, ";"))#ok
k7 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K7.txt", sep = ""), header = TRUE, "\t"))
