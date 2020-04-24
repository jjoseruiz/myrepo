recorreImagenes<-function(IMAGENES,COORDENADAS)
{
  #las IMAGENES VENDRAN EN UNA LISTA IGUAL QUE LAS COORDENADAS
  listaValores<-list(valoresImagen(IMAGENES[i],COORDENADAS[i]))
  return(listaValores)
}