library(tidyverse)
 
source("Case_Study_Group_04_files/tidy_dataset.R")

component_tibbles <- vector(mode = "list", length = 16)
names(component_tibbles) <- c(
  "K1BE1", "K1BE2", "K1DI1", "K1DI2",
  "K2LE1", "K2LE2", "K2ST1", "K2ST2",
  "K3AG1", "K3AG2", "K3SG1", "K3SG2",
  "K4", "K5", "K6", "K7")

#read data using read.delim and the separators 
#K1
component_tibbles$K1BE1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1BE1.csv",sep = ""), head = TRUE, ","))
component_tibbles$K1BE2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1BE2.csv",sep = ""), head = TRUE, ";"))
component_tibbles$K1DI1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K1DI1.csv",sep = ""), head = TRUE, ","))

#K1di2 
component_tibbles$K1DI2 <- readChar('Data/Komponente/Komponente_K1DI2.txt', file.info('Data/Komponente/Komponente_K1DI2.txt')$size)
component_tibbles$K1DI2 <- gsub('[[:blank:]]', '\\', component_tibbles$K1DI2)
component_tibbles$K1DI2 <- gsub('""', '"\n"', component_tibbles$K1DI2)
component_tibbles$K1DI2 <- tidy_dataset(read.delim(text = component_tibbles$K1DI2, header = TRUE , sep = '\\'))

#K2
component_tibbles$K2LE2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2LE2.txt",sep = ""), header = TRUE, "\\"))
component_tibbles$K2ST1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2ST1.txt",sep = ""), header = TRUE, "|"))
component_tibbles$K2ST2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K2ST2.csv",sep = ""), header = TRUE, ";"))

#K2le1
component_tibbles$K2LE1 <- readChar('Data/Komponente/Komponente_K2LE1.txt', file.info('Data/Komponente/Komponente_K2LE1.txt')$size)
component_tibbles$K2LE1 <- gsub('\x0B"', '\n"', component_tibbles$K2LE1)
component_tibbles$K2LE1 <- gsub('II', ' ', component_tibbles$K2LE1)
component_tibbles$K2LE1 <- tidy_dataset(read.delim(text = component_tibbles$K2LE1, header = TRUE , sep = ' '))

#K3
component_tibbles$K3AG1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3AG1.csv",sep = ""), header = TRUE, ","))
component_tibbles$K3AG2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3AG2.txt", sep = ""), header = TRUE, "\\"))
component_tibbles$K3SG1 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3SG1.csv",sep = ""), header = TRUE, ","))
component_tibbles$K3SG2 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K3SG2.csv",sep = ""), header = TRUE, ","))

#K4 -k7
component_tibbles$K4 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K4.csv", sep = ""), header = TRUE, ";"))
component_tibbles$K5 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K5.csv", sep = ""), header = TRUE, ","))
component_tibbles$K6 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K6.csv", sep = ""), header = TRUE, ";"))
component_tibbles$K7 <-  tidy_dataset(read.delim(paste("Data/Komponente/Komponente_K7.txt", sep = ""), header = TRUE, "\t"))

