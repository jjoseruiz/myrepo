recorreImagenes<-function(IMAGENES,COORDENADAS)
{
  
  #las IMAGENES VENDRAN EN UNA LISTA 
  #Las coordenadas serán una matriz de coordenadas
  listaValores = lapply(IMAGENES,valoresImagen,COORDENADAS = COORDENADAS)
  return(listaValores)
}