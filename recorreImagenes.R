recorreImagenes<-function(IMAGENES,COORDENADAS)
{
  
  #las IMAGENES VENDRAN EN UNA LISTA 
  #Las coordenadas serán una matriz de coordenadas
  longitud = length(IMAGENES)
  i = 1
  listaValoresi = list()
  while(i<=longitud){
    listaValoresi<-list(listaValoresi,valoresImagen(IMAGENES[[i]],COORDENADAS))
    i = i + 1
  }
  return(listaValoresi)
}