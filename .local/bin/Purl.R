  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  ### Render.R:
  ### Configuración única para crear documento pdf usando rmarkdown.
  ### Evitar escribir siempre el mismo código de configuración.
  ### Usar la terminal + R en modo esclavo
  ### Revisar función Render creada en archivo $HOME/.bashrc
  Render <- function( inpfle , outfle , strnum )
  {
    require(knitr)
    knitr::purl( inpfle , outfle , documentation = strnum , quiet=TRUE )
  }

  if(!interactive()){
    Render(
    inpfle  = args[1],
    outfle  = args[2],
    strnum  = args[3]
    )
  }
