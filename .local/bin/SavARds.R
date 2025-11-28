  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  SavARds <- function( strsav , strrds , strdfm )
  {
    require(haven)
    strdfm <- haven::read_spss( file = strsav )
    saveRDS( strdfm , file = strrds )
  }

  if(!interactive()){
    strdfm  <-
    SavARds(
    strsav  = args[1]
   ,strrds  = args[2]
   ,strdfm  = args[3]
    )
  }
