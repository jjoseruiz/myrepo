source("estaEnLista.R")
source("elegirVoxeles.R")
source("obtenCoord.R")
source("valoresImagen.R")
source("recorreImagenes.R")
source("devuelveImagenes.R")
listaFunciones = c(mean,min,max,sd)
numero_voxeles = 2000
#listaImagenes = devuelveImagenes()
listaImagenes=list(ws_flair,ws_t1)
#consensos = lapply(consensopath,readnii)
for(l in 1:1){
  mismoSujeto = c(listaImagenes[l],listaImagenes[length(listaImagenes)/2+l])
  coordenadas = elegirVoxeles(numero_voxeles,consenso)
  vecinos = recorreImagenes(mismoSujeto,coordenadas)
  #i será el número de imágenes y j el número de vóxeles por imagen
  almacen = aplicaFunciones(vecinos,listaFunciones)
}

