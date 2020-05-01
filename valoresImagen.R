valoresImagen<-function(IMAGEN,COORDENADAS){
  coord = list()
  if(!is.antsImage(IMAGEN)){
    imagenants = as.antsImage(IMAGEN)
  }else{
    imagenants = IMAGEN
  }
  for(i in 1:nrow(COORDENADAS)){
    ventana = getNeighborhoodAtVoxel(imagenants,center = c(COORDENADAS[i,1],COORDENADAS[i,2],COORDENADAS[i,3]),c(1,1,1))
    valores = c(list(ventana$values),coord)
    coord = valores
  }
  return(valores)
}