obtenCoord<-function(num,Imagen)
{
  num = 10778777
  fila = num%%nrow(Imagen)
  if (fila==0){
    fila = nrow(Imagen)
    columna = num/nrow(Imagen)
  }else{
    columna = trunc(num/nrow(Imagen))+1
  }
  if(columna>=ncol(Imagen)){
    while(!columna<ncol(Imagen)){
      columna = columna%%ncol(Imagen)
    }
    if(columna == 0)
      columna = ncol(Imagen)
  }
  dim = nrow(Imagen)*ncol(Imagen)
  prof = num%%dim
  if(prof !=0){
    prof = trunc(num/dim)+1
  }else{
    prof = dim(Imagen)[3]
  }
  return(c(fila,columna,prof))
}
