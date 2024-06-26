#!/usr/bin/env R

suppressPackageStartupMessages({
  library(arrow)
  library(data.table)
})

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
}

CsvAParquet <- function( strcsv , strprq , strdlm )
{
  strdfm <- fread(strcsv, sep=strdlm, quote="", fill=T)
  write_parquet( strdfm , strprq , compression="brotli", compression_level=11 )
}

if(!interactive()){
  strdfm  <-
  CsvAParquet(
  strcsv  = args[1]
 ,strprq  = args[2]
 ,strdlm  = args[3]
  )
}
