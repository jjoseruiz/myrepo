arr = array(data = 1:24,dim = c(192,512,512))
num = 10778777
fila = num%%nrow(arr)
  if (fila==0){
    fila = nrow(arr)
   columna = num/nrow(arr)
  }else{
    columna = trunc(num/nrow(arr))+1
  }
if(columna>=ncol(arr)){
  while(!columna<ncol(arr)){
    columna = columna%%ncol(arr)
  }
  if(columna == 0)
    columna = ncol(arr)
}
dim = nrow(arr)*ncol(arr)
prof = num%%dim
if(prof !=0){
  prof = trunc(num/dim)+1
}else{
  prof = dim(arr)[3]
}
fila
columna
prof
