elegirVoxeles<-function(num_voxel,mascara_gt)
{
  #creamos una funcion a parte para comprobar si una coordenada ya estaba introducida
  source("estaEnLista.R")
  if(num_voxel>1  & num_voxel%%2==0){
    if(!is.antsImage(mascara_gt)){
      #si la imagen/mascara gt que nos dan no es de tipo ants, la transformamos
      ants_mascara = as.antsImage(mascara_gt)
    }else{
      #si lo es, asignamos su valor a la variable ants_mascara
      ants_mascara = mascara_gt
      mascara = as.nifti(mascara_gt)
    }
    lesion = which(ants_mascara>0)
    sano = which(ants_mascara<1)
    i  = 0
    j = 0
    indices = matrix(nrow = num_voxel,ncol = 3) 
    while(i<num_voxel/2){
      coordLes = obtenCoord(sample(lesion,1),mascara_gt)
      if(!estaEnLista(indices,coordLes) & i<num_voxel/2){
        vecinosLes = getNeighborhoodAtVoxel(ants_mascara,coordLes,c(1,1,1))
        values_Les = vecinosLes$values>0
        l=0
        while(l<length(vecinosLes$values) & i<num_voxel/2){
          l = l+1
          if(values_Les[l] & i<num_voxel/2 & !estaEnLista(indices,vecinosLes$indices[l,1:ncol(indices)])){
            i = i + 1
            print(paste0("voxel LESION Nº-->",i))
            indices[i+j,1:ncol(indices)] = vecinosLes$indices[l,1:ncol(indices)]
          }
        }
      }
    }
    while(j<num_voxel/2){
      coordSan = obtenCoord(sample(sano,1),mascara_gt)
      vecinosSan = getNeighborhoodAtVoxel(ants_mascara,coordSan,c(1,1,1))
      values_San = vecinosSan$values<1
      l=0
      while(l<length(vecinosSan$values) & j<num_voxel/2)
      {
        l = l+1
        condSano = values_San[l]
        if(is.na(condSano))
          condSano = FALSE
        if(condSano & j<num_voxel/2 & !estaEnLista(indices,vecinosSan$indices[l,1:ncol(indices)]))
        {
          j = j + 1
          print(paste0("voxel SANO Nº-->",j))
          indices[i+j,1:ncol(indices)] = vecinosSan$indices[l,1:ncol(indices)]
        }
      }
    }
    return(indices)
  }
}

