devuelveImagenes <- function()
{
  pathT1<-c()
  pathFlair<-c()
  for(l in 1:30){
    pathT1 = c(path1,file.path("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES",paste0("S",l,"_T1_BRAIN.nii.gz")))
    pathFlair = c(pathflair,file.path("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES",paste0("S",l,"_FLAIR_BRAIN.nii.gz")))
  }
  t1 = lapplay(pathT1,readnii)
  flair = lapply(pathFlair,readnii)
  listaImagenes = c(t1,flair)
  return (listaImagenes)
}