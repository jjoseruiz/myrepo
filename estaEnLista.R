estaEnLista<-function(matriz,coordenada)
{
  esta = FALSE
  i=1
  while ( i<= nrow(matriz) & !esta){
    vacio = is.na(matriz[i,1:ncol(matriz)])
    condicionvacio = vacio[1]&vacio[2]&vacio[3]
    if(condicionvacio){
      esta = FALSE
    }else{
      fila = matriz[i,1:ncol(matriz)]
      if(fila[1]==coordenada[1] & fila[2]==coordenada[2] & fila[3]==coordenada[3]){
        esta = TRUE
      }
    }
    i = i+1
  }
  return (esta)
}