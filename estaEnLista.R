estaEnLista<-function(matriz,coordenada)
{
    for(i in 1:nrow(matriz)){
      vacio = is.na(matriz[i,1:ncol(matriz)])
      condicionvacio = vacio[1]&vacio[2]&vacio[3]
      if(condicionvacio){
        return(FALSE)
      }else{
        fila = matriz[i,1:ncol(matriz)]
        if(fila[1]==coordenada[1] & fila[2]==coordenada[2] &fila[3]==coordenada[3]){
          return(TRUE)
        }
      }
    }
    return(FALSE)
}