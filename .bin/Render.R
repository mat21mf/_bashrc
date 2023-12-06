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
  Render <- function( strfle )
  {
    require(rmarkdown)
    options(tinytex.engine_args=" -shell-escape")
    rmarkdown::render(strfle)
  }

  if(!interactive()){
    Render(
    strfle  = args[1]
    )
  }
