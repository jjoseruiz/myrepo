aplicaFunciones<-function(listaValores,listaFunciones)
{
  listaFeatures = matrix(nrow = 2*length(listaValores[[1]]),ncol = length(listaFunciones)+1)
  for(i in 1:length(listaValores)){
    for (j in 1:length(listaFunciones)){
      #aplicamos la función j a la ventana iésimo
      features = c(lapply(listaValores[[i]],listaFunciones[[j]]))
      feat = c()
      for(l in 1:length(features)){
        feat = c(feat,features[[l]])
      }
      if(i == 1)
      listaFeatures[1:(nrow(listaFeatures)/2),j] = feat
      
      else{
        listaFeatures[((nrow(listaFeatures))/2+1):nrow(listaFeatures),j]=feat
      }
    }
    if(i == 1){
      #los primeros nvoxel/2 son LESION
      listaFeatures[1:(length(listaValores[[1]])/2),ncol(listaFeatures)] = 1
      #los segundos nvoxel/2 son SANOS
      listaFeatures[(length(listaValores[[1]])/2+1):length(listaValores[[1]])/2,ncol(listaFeatures)] = 0
    }else{
      listaFeatures[((nrow(listaFeatures))/2+1):(nrow(listaFeatures)*3/4),ncol(listaFeatures)] = 1
      listaFeatures[((nrow(listaFeatures)*3/4)+1):nrow(listaFeatures),ncol(listaFeatures)] = 0
    }
  }
  return (listaFeatures)
}