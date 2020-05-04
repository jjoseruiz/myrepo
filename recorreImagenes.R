recorreImagenes<-function(IMAGENES,COORDENADAS)
{
  
  #las IMAGENES VENDRAN EN UNA LISTA 
  #Las coordenadas serán una matriz de coordenadas
  mat = matrix(nrow = nrow(COORDENADAS),ncol = length(IMAGENES)*27)
  l=0
  for(i in 1:length(IMAGENES)){
    v = valoresImagen(IMAGENES[[i]],COORDENADAS)
    valores = sacoValorVecinos(IMAGENES[[i]],v)
    mat[1:nrow(valores),(1+l):(l+ncol(valores))]=valores
    l=l+ncol(valores)
  }
  #listaValores = lapply(IMAGENES,valoresImagen,COORDENADAS = COORDENADAS)
  return(mat)
}