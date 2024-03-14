#!/usr/bin/env R

args <- commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
}

suppressPackageStartupMessages({
  library(data.table)
  library(openxlsx)
})

XlsxARds <- function( strxls , strsht , strout ){

  ### echo
  print(paste0(rep("#", 200), collapse = ""))
  print(paste("### Convirtiendo:"))
  print(paste("###", strxls))
  print(paste("### En:"))
  print(paste("###", strout))
  print(paste0(rep("#", 200), collapse = ""))
  cat('\n')

  ### cargar
  if( strsht == "" ) {
    objdfm <- setDT( read.xlsx( strxls ) )
  } else {
    objdfm <- setDT( read.xlsx( strxls , sheet = strsht ) )
  }
  saveRDS( objdfm , strout , compress = TRUE )

}

if (!interactive()) {
  objdfm <- XlsxARds(
    strxls = args[1] ,
    strsht = args[2] ,
    strout = args[3]
  )
}
