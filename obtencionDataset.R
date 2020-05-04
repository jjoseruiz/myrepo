source("estaEnLista.R")
source("elegirVoxeles.R")
source("obtenCoord.R")
source("valoresImagen.R")
source("recorreImagenes.R")
source("devuelveImagenes.R")
source("aplicaFuncion.R")
listaFunciones = c(mean,min,max,sd)
numero_voxeles = 2000
#listaImagenes = devuelveImagenes()
listaImagenes=list(S1_FLAIR_BRAIN,readnii("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/S1_T1_BRAIN.nii.gz"))
#consensos = lapply(consensopath,readnii)
consenso = readnii("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_consensus_gt.nii.gz")
dataset = matrix(nrow = numero_voxeles,ncol = (length(listaFunciones)*length(listaImagenes)))
nSujetos = 1
almacen = matrix(nrow = numero_voxeles,ncol = (ncol(dataset)*nSujetos)+1)
j=0
for(l in 1:(length(listaImagenes)/2)){
  mismoSujeto = list(listaImagenes[[l]],listaImagenes[[length(listaImagenes)/2+l]])
  coordenadas = elegirVoxeles(numero_voxeles,consenso)
  vecinos = recorreImagenes(mismoSujeto,coordenadas)
  
  #i será el número de imágenes y j el número de vóxeles por imagen
  dataset[,1:(ncol(dataset))] = aplicaFuncion(vecinos,listaFunciones)
  #sabemos que los nvoxel/2 eran sanos por lo que, la feature gt será

  almacen[,(j+1):(ncol(dataset)+j)]=dataset
  j=j+ncol(dataset)
  }
almacen[1:numero_voxeles/2,ncol(almacen)]=1
almacen[(numero_voxeles/2+1):numero_voxeles,ncol(almacen)]=0

