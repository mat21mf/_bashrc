#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(arrow)
  library(data.table)
  library(openxlsx)
})

XlsxAParquet <- function( strxls , strsht , strout ) {
  if( strsht == "" ) {
    objdfm <- setDT( read.xlsx( strxls ) )
  } else {
    objdfm <- setDT( read.xlsx( strxls , sheet = strsht ) )
  }
  write_parquet( objdfm , strout , compression = "brotli" , compression_level = 11 )
}

if (!interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  objdfm <- XlsxAParquet(
    strxls = args[0] ,
    strsht = args[1] ,
    strout = args[2]
  )
}
