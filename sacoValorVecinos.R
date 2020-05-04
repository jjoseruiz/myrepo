sacoValorVecinos<-function(IMAGEN,matrizC)
{
  #los valores de los 27 vecinos
  mat = matrix(nrow = nrow(matrizC),ncol = 27)
  aux = 0
  for(i in 1:nrow(matrizC)){
    for(j in 1:ncol(mat)){
      if(j == 1){
        mat[i,j]=IMAGEN[matrizC[i,j:3][1],matrizC[i,j:3][2],matrizC[i,j:3][3]]
        aux = 3
      }else{
        mat[i,j]=IMAGEN[matrizC[i,(aux+1):(3*j)][1],matrizC[i,(aux+1):(3*j)][2],matrizC[i,(aux+1):(3*j)][3]]
        aux = 3*j
      }
    }
  }
  return (mat)
}