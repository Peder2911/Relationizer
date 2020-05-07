#!/usr/bin/Rscript

data <- read.csv(commandArgs(trailingOnly = TRUE)[1],stringsAsFactors = FALSE)
keycol <- commandArgs(trailingOnly = TRUE)[2]
if(is.na(keycol) | is.null(keycol)){
   stop("Usage: getmul.R [data] [keycolumn]")
}

mul <- data[data[[keycol]] %in% data[duplicated(data[[keycol]]),keycol],]
write.csv(mul,'mul.csv',row.names = FALSE)
