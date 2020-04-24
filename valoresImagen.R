valoresImagen<-function(IMAGEN,COORDENADAS){
  indices = c()
  for(i in 1:nrow(COORDENADAS)){
    indices = c(indices,IMAGEN[COORDENADAS[i,1],COORDENADAS[i,2],COORDENADAS[i,3]])
  }
  return(indices)
}