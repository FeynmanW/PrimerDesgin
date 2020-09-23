#!/usr/bin/env Rscript
# Title: Automatic construction of Primers for Sequence Insertion ####
# Author: Wang Bo https://github.com/FeynmanW ####

# CRAN package
CRAN_packages <- c("optparse")
installLoad_CRAN <- function(package){
  if (!require(package, character.only = T)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = T, quietly = T)
  }
}
sapply(CRAN_packages, installLoad_CRAN)

library("optparse")

# Parsing Arguments ############################################################
option_list = list(
  make_option(c("-o", "--output"), type="character", default = "output_primer",
              help="Set the prefix of output file name", metavar="character"),
  make_option(c("-n", "--number"), type="integer", default = 1,
              help="Number of primers to design", metavar="integer"),
  make_option(c("-i", "--input"), type="character", default = NULL,
              help="Input file consist of overlap sequence for Gibson assembly and reference sequence", metavar="character"),
  make_option(c("-g", "--gap"), type="integer", default = 1,
              help="Selection gap for insertion sites [default= %default]", metavar="numeric")
)
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser)

inputfile <- opt$input
gap <- opt$gap
n <- opt$number
outputfile <- opt$output

calculateGCcontent <- function(dnaSeq){
  dnaSeq <- strsplit(toupper(dnaSeq), split = "")[[1]]
  len <- length(dnaSeq)
  count <- 0
  for (i in 1:len) {
    if (dnaSeq[i] == "G" | dnaSeq[i] == "C") {
      count <- count + 1
    }
  }
  count / len * 100
}

calculateTm <- function(dnaSeq){
  GCcontent <- calculateGCcontent(dnaSeq)
  dnaSeq <- strsplit(toupper(dnaSeq), split = "")[[1]]
  len <- length(dnaSeq)
  69.3 + 0.41 * GCcontent - 650/len
}

refSeq <- read.csv(inputfile, header = F)
for (i in 1:nrow(refSeq)) {
  overlap <- toupper(refSeq[i, 1])
  ref <- refSeq[i, 2]
  primer <- data.frame(sequence=character(), stringsAsFactors = FALSE)
  for (j in 1:n){
    linkPrimer <- substr(ref, (j-1)*gap*3+1, (j-1)*gap*3+20)
    if (calculateTm(linkPrimer) > 65) linkPrimer <- substr(ref, (j-1)*gap*3+1, (j-1)*gap*3+18)
    primer[j,1] <- paste0(overlap, linkPrimer)
  }
  write.table(primer, file = paste0(outputfile, "_", i, ".csv"), sep = ",", quote = F, row.names = F, col.names = T)
}
