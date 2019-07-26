library(tidyverse)

#read file
library(tidyverse)
fileName1 <- 'Komponente_K1DI2.txt'
striga <- readChar(fileName1, file.info(fileName1)$size)
striga <- gsub("\\", "|", striga, fixed = TRUE)
striga <- gsub("\"", "", striga, fixed = FALSE)
striga <- gsub("\t", "", striga, fixed = FALSE)
read.delim(striga,  header = TRUE, sep = "|")
K1di2 <- write.table(striga, append = FALSE, sep = "I")
K1di2 <- tidy_dataset(read.delim(text = striga.txt, header = TRUE, sep = "|"))#Problem

library(tidyverse)
fileName2 <- 'Komponente_K2LE1.txt'
strigaros <- readChar(fileName2, file.info(fileName2)$size)
strigaros <- gsub("II", " ", strigaros, fixed = TRUE)
strigaros <- gsub("\"", " ", strigaros, fixed = TRUE)
strigaros <- gsub("\x0B", "", strigaros, fixed = FALSE)
strigaros <- gsub("  ", " ", strigaros, fixed = TRUE)
read.delim(strigaros,  header = TRUE, sep = " ")
k2le1 <- read.delim(text = strigaros,  header = TRUE, sep = " ", nrows = 5)

library(tidyverse)

#read file
#K1

K1be1 <- tidy_dataset(read_csv("Komponente_K1BE1.csv"))
K1be2 <- tidy_dataset(read_csv2("Komponente_K1BE2.csv"))
K1di1 <- tidy_dataset(read_csv("Komponente_K1DI1.csv"))


#K2
K2le2 <- tidy_dataset(read_delim("Komponente_K2LE2.txt", header = TRUE, sep = "\\")) 
K2Sst1 <- tidy_dataset(read_delim2("Komponente_K2ST1.txt", header = TRUE, sep = "|")) 
K2st2 <- tidy_dataset(read_csv2("Komponente_K2ST2.csv"))
library(tidyverse)
fileName2 <- 'Komponente_K2LE1.txt'
strigaros <- readChar(fileName2, file.info(fileName2)$size)
strigaros <- gsub("II", " ", strigaros, fixed = TRUE)
strigaros <- gsub("\"", " ", strigaros, fixed = TRUE)
strigaros <- gsub("\x0B", "", strigaros, fixed = FALSE)
strigaros <- gsub("  ", " ", strigaros, fixed = TRUE)
read.delim(strigaros,  header = TRUE, sep = " ")

#K3

k3ag1 <- tidy_dataset(read_csv("Komponente_K3AG1.csv"))
k3ag2 <- tidy_dataset(read_delim("Komponente_K3AG2.txt", header = TRUE, sep = "\\"))
k3sg1 <- tidy_dataset(read_csv("Komponente_K3SG1.csv"))
k3sg2 <- tidy_dataset(read_csv("Komponente_K3SG2.csv"))

#K4 -k7

k4 <- tidy_dataset(read_csv2("Komponente_K4.csv"))
k5 <- tidy_dataset(read_csv("Komponente_K5.csv"))
k6 <- tidy_dataset(read_csv2("Komponente_K6.csv"))
k7 <- tidy_dataset(read_delim2("Komponente_K7.txt"))