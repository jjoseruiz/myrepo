library(neurobase)
library(ANTsR)
library(ANTsRCore)
library(extrantsr)
#importante ese orden para representar antsImagenes con ortho2 y doubleortho
pathImagenes="/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/"
imgFLAIR=antsImageRead(paste0(pathImagenes,"S1_FLAIR_BRAIN.nii.gz"))
imgT1=antsImageRead(paste0(pathImagenes,"S1_T1_BRAIN.nii.gz"))
#Eliminamos los valores negativos para no tener problemas con el registro.
FLAIR=imgFLAIR+abs(min(imgFLAIR))
T1=imgT1+abs(min(imgT1))
#reflejo flair
reflejoFlair = reflectImage(FLAIR,2,tx="AffineFast",verbose=TRUE)
asymFlair=FLAIR-reflejoFlair$warpedmovout
#reflejo T1
reflejoT1=antsApplyTransforms(T1,T1,transformlist = reflejoFlair$fwdtransforms)
asymT1=T1-reflejoT1

