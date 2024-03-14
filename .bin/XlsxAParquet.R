#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
}

suppressPackageStartupMessages({
  library(arrow)
  library(data.table)
  library(openxlsx)
})

XlsxAParquet <- function( strxls , strsht , strout ) {

  ### echo
  print(paste0(rep("#", 200), collapse = ""))
  print(paste("### Convirtiendo:"))
  print(paste("###", strxls))
  print(paste("### En:"))
  print(paste("###", strout))
  print(paste0(rep("#", 200), collapse = ""))
  cat('\n')

  # cargar
  if( strsht == "" ) {
    objdfm <- setDT( read.xlsx( strxls ) )
  } else {
    objdfm <- setDT( read.xlsx( strxls , sheet = strsht ) )
  }
  write_parquet( objdfm , strout , compression = "brotli" , compression_level = 11 )

}

if (!interactive()) {
  objdfm <- XlsxAParquet(
    strxls = args[1] ,
    strsht = args[2] ,
    strout = args[3]
  )
}
