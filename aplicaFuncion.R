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
      listaFeatures[1:nrow(listaFeatures),j] = feat
    }
  }
  
  return (listaFeatures)
}