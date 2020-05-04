valoresImagen<-function(IMAGEN,COORDENADAS){
  #27 vecinos por 3 coordenadas cada uno.
  coord = matrix(nrow = nrow(COORDENADAS),ncol = 27*3,byrow = TRUE)
  if(!is.antsImage(IMAGEN)){
    imagenants = as.antsImage(IMAGEN)
  }else{
    imagenants = IMAGEN
  }
  for(i in 1:nrow(COORDENADAS)){
    ventana = getNeighborhoodAtVoxel(imagenants,center = c(COORDENADAS[i,1],COORDENADAS[i,2],COORDENADAS[i,3]),c(1,1,1))
    coordi = ventana$indices
    ordenada = c()
    for(j in 1:nrow(coordi)){
      ordenada=c(coordi[j,1:3],ordenada)
    }
    #cada tres columnas tenemos las coordenadas de un vecino
    coord[i,1:81]=ordenada
  }
  #hay que tener en cuenta que los primeros numvoxel/2 son LESION
  #Los numVoxel/2 siguientes son SANOS
  return(coord)
}