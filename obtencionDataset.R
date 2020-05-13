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
#nSujetos = devuelveImagenes()
nSujetos=list(S1_FLAIR_BRAIN,readnii("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/S1_T1_BRAIN.nii.gz"))
rootflair1 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",1,"_FLAIR_BRAIN.nii.gz")
rootflair2 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",2,"_FLAIR_BRAIN.nii.gz")
rootflair4 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",4,"_FLAIR_BRAIN.nii.gz")
roott11 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",1,"_T1_BRAIN.nii.gz")
roott12 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",2,"_T1_BRAIN.nii.gz")
roott14 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",4,"_T1_BRAIN.nii.gz")
lroot = list(rootflair1,rootflair2,rootflair4,roott11,roott12,roott14)
nSujetos = lapply(lroot,antsImageRead)
#nSujetos = list(t1s1,t2s2,flairs1,flairs2)
#consensos = lapply(consensopath,readnii)
rootconsenso1 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",1,"_CONSENSO.nii.gz")
rootconsenso2 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",2,"_CONSENSO.nii.gz")
rootconsenso4 = paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",4,"_CONSENSO.nii.gz")
lconsenso = list(rootconsenso1,rootconsenso2,rootconsenso4)
consensos = lapply(lconsenso,antsImageRead)
#consenso = readnii("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_consensus_gt.nii.gz")
#consenso = consenso1
#consenso  = consenso2
nSujetos = 30
num_images_sujeto = 2
almacen = matrix(nrow = numero_voxeles*nSujetos,ncol = length(listaFunciones)*num_images_sujeto+1)
j=0
for(l in 1:numImagenes){
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




