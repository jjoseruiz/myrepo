valoresImagen<-function(IMAGEN,COORDENADAS){
  valores = c()
  for(i in 1:nrow(COORDENADAS)){
    valores = c(valores,IMAGEN[COORDENADAS[i,1],COORDENADAS[i,2],COORDENADAS[i,3]])
  }
  return(valores)
}