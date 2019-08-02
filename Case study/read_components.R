  library(tidyverse)
 
#read data using read.delim and the separators 
#K1
  
K1be1 <-  read.delim(paste("Data/Komponente/Komponente_K1BE1.csv",sep = ""), head = TRUE, ",")
K1be2 <-  read.delim(paste("Data/Komponente/Komponente_K1BE2.csv",sep = ""), head = TRUE, ";")
K1di1 <-  read.delim(paste("Data/Komponente/Komponente_K1DI1.csv",sep = ""), head = TRUE, ",")
#K1di2 
fileName1 <- 'Data/Komponente/Komponente_K1DI2.txt'
striga <- readChar(fileName1, file.info(fileName1)$size)
striga <- gsub("\\", "|", striga, fixed = TRUE)
striga <- gsub("\"", "", striga, fixed = FALSE)
striga <- gsub("\t", "", striga, fixed = FALSE)
read.delim(striga,  header = TRUE, sep = "|")
write_lines( striga,"striga_reduced.txt")
# es gibt manche whitespaces im txt file 
K1di2 <- read.delim(paste("striga_reduced.txt", sep = "") , header = TRUE , "|")

  
  
#K2
K2le2 <-  read.delim(paste("Data/Komponente/Komponente_K2LE2.txt",sep = ""), header = TRUE, "\\")
K2st1 <-  read.delim(paste("Data/Komponente/Komponente_K2ST1.txt",sep = ""), header = TRUE, "|")
K2st2 <-  read.delim(paste("Data/Komponente/Komponente_K2ST2.csv",sep = ""), header = TRUE, ";")
#K2le1
fileName2 <- 'Data/Komponente/Komponente_K2LE1.txt'
strigaros <- readChar(fileName2, file.info(fileName2)$size)
strigaros <- gsub("II", "|", strigaros, fixed = TRUE)
strigaros <- gsub("\"", "|", strigaros, fixed = TRUE)
strigaros <- gsub("\x0B", "", strigaros, fixed = FALSE)
#strigaros <- gsub(strigaros, fixed = FALSE))
strigaros <- gsub(" ", "", strigaros, fixed = FALSE)
strigaros <- gsub("|||", "|", strigaros, fixed = TRUE)
strigaros <- gsub("||", "|", strigaros, fixed = TRUE)
read.delim(strigaros,  header = TRUE, sep = " ")
write_lines( strigaros ,"strigaros_reduced.txt")
# es gibt manche whitespaces im txt file 
K2le1 <- K1di2 <- read.delim(paste("strigaros_reduced.txt", sep = "") , header = TRUE , " ")

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
