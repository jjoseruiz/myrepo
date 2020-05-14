source("estaEnLista.R")
source("elegirVoxeles.R")
source("obtenCoord.R")
source("valoresImagen.R")
source("recorreImagenes.R")
source("devuelveImagenes.R")
source("aplicaFuncion.R")
source("sacoValorVecinos.R")
listaFunciones = c(mean,min,max,sd)
numero_voxeles = 2000
nSujetos = 30
num_images_sujeto = 2
numImagenes = 30*2
almacen = matrix(nrow = numero_voxeles*nSujetos,ncol = length(listaFunciones)*num_images_sujeto+1)
nombrecolumnas = c("MEAN_FLAIR","MIN_FLAIR","MAX_FLAIR","SD_FLAIR","MEAN_T1","MIN_T1","MAX_T1","SD_T1","LESION")
colnames(almacen)<-nombrecolumnas
j=0
for(l in 1:nSujetos){
  rootflairl = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",l,"_FLAIR_BRAIN.nii.gz")
  roott1l = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",l,"_T1_BRAIN.nii.gz")
  rootconsensol = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",l,"_CONSENSO.nii.gz")
  rots = list(rootflairl,roott1l)
  mismoSujeto = lapply(rots,antsImageRead)
  consenso =antsImageRead(paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",l,"_CONSENSO.nii.gz"))
  
  coordenadas = elegirVoxeles(numero_voxeles,consenso)
  vecinos = recorreImagenes(mismoSujeto,coordenadas)
  
  #i será el número de imágenes y j el número de vóxeles por imagen
  dataset = aplicaFuncion(vecinos,listaFunciones)
  #sabemos que los nvoxel/2 eran sanos por lo que, la feature gt será

  almacen[(j+1):(j+nrow(dataset)),1:ncol(dataset)]=dataset
  almacen[(j+1):(j+nrow(dataset)/2),ncol(almacen)]=1
  almacen[((j+nrow(dataset)/2)+1):(j+nrow(dataset)),ncol(almacen)]=0
  j=j+nrow(dataset)
}




