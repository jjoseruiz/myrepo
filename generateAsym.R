library(neurobase)
library(ANTsR)
library(ANTsRCore)
library(extrantsr)
#importante ese orden para representar antsImagenes con ortho2 y doubleortho
for(i in 1:30)
{
  pathImagenes="/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/"
  imgFLAIR=antsImageRead(paste0(pathImagenes,"S",i,"_FLAIR_BRAIN.nii.gz"))
  imgT1=antsImageRead(paste0(pathImagenes,"S",i,"_T1_BRAIN.nii.gz"))
  #Eliminamos los valores negativos para no tener problemas con el registro.
  mf=min(imgFLAIR)
  mt=min(imgT1)
  FLAIR=imgFLAIR-mf+1
  T1=imgT1-mt+1
  #reflejo flair
  reflejoFlair = reflectImage(FLAIR,0,"AffineFast",verbose=TRUE)
  reflejoFlair=reflejoFlair$warpedmovout+mf-1
  asymFlair=FLAIR-reflejoFlair
  antsImageWrite(reflejoFlair,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/SIMETRIA/S",i,"_FLAIR_SIMETRICA.nii.gz"))
  antsImageWrite(asymFlair,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/SIMETRIA/S",i,"_FLAIR_ASIMETRICA.nii.gz"))
  #reflejo T1
  reflejoT1=reflectImage(T1,0,"AffineFast",verbose=TRUE)
  reflejoT1=reflejoT1$warpedmovout+mt-1
  asymT1=T1-reflejoT1
  antsImageWrite(reflejoT1,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/SIMETRIA/S",i,"_T1_SIMETRICA.nii.gz"))
  antsImageWrite(asymT1,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/SIMETRIA/S",i,"_T1_ASIMETRICA.nii.gz"))
}


