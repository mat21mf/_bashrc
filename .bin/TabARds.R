  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  TabARds <- function( strtab , strrds , strdfm )
  {
    strdfm <- utils::read.csv(file=strtab, sep="\t", header=TRUE)
    saveRDS( strdfm , file = strrds )
  }

  if(!interactive()){
    strdfm  <-
    TabARds(
    strtab  = args[1]
   ,strrds  = args[2]
   ,strdfm  = args[3]
    )
  }
