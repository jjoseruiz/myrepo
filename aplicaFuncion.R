aplicaFuncion<-function(vecinos,listaFunciones)
{
  #n es el número de imágenes
  n = ncol(vecinos)/27
  listaFeatures = matrix(nrow = nrow(vecinos),ncol = length(listaFunciones)*n)
    for(i in 1:nrow(vecinos)){
      lista = list()
      #variables auxiliares
      c=0
      k=1
      #aplicamos la función j a la ventana iésimo
      #n es el número de imágenes
      #almacenamos en una lista. Cada posición de la lista corresponde con el conjunto de vecinos de la imagen n y vóxel iésimo
      for(p in 1:n){
        valuesk = list(vecinos[i,(c+1):(k*27)])
        c=k*27
        k=k+1
        #almacenamos en lista los vectores de los valores cada imagen correspondientes al vóxel iésimo
        lista = c(lista,valuesk)
      }
      #aplicamos la función jésima a cada elemento de la lista
      for (j in 1:length(listaFunciones)){
        features = c(lapply(lista,listaFunciones[[j]]))
        #lo convertimos en vector
        feat = c()
        for(l in 1:length(features)){
          feat = c(feat,features[[l]])
        }
        #repartimos el resultado de la función en las columnas de la matriz 
        #razon reparto.
        r = ncol(listaFeatures)/n
        b=0
        while(b<(length(listaFunciones)-2)){
          listaFeatures[i,j+b*r]=feat[b+1]
          b=b+1
        }
      }
    }
  return (listaFeatures)
}