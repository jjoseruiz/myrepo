setwd("/Users/juanjoseruizpenela/Documents/WORKSPACE/TFG")
source("correccion.R")
source("leeImagen.R")
source("registro.R")
library(neurobase)
library(ANTsR)
library(extrantsr)
library(WhiteStripe)
#Configuración del registro
s1_FLAIR_CORRECTED=correccion(readnii("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_FLAIR.nii.gz"))
lT1<-c()
lFLAIR<-c()
lBMASK<-c()
lB_FLAIR<-c()
lB_T1<-c()

#PARA MI DATASET DE MRI APLICAREMOS LA SIGUIENTE SECUENCIA DE PASOS
for (i in 1:2){
  ###LECTURA
  print(paste0("Leyendo Imagen T1 del sujeto ",i))
  IMG_T1 = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","T1",i)
  print(paste0("Leyendo Imagen FLAIR del sujeto ",i))
  IMG_FLAIR = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","FLAIR",i)
  print(paste0("Leyendo Máscara del sujeto ",i))
  IMG_MASK = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","brainmask",i)
  
  
  
  ###CORRECCIÓN
  print("Corrigiendo T1 con el algoritmo N3")
  T1_CORRECT = correccion(IMG_T1)
  print("Corrigiendo FLAIR con el algoritmo N3")
  if(i==1){
    print("primera iteración")
    FLAIR_CORRECT=s1_FLAIR_CORRECTED
    #cogemos la FLAIR de referencia para registrar todas la demás en su espacio.
  }else{
    FLAIR_CORRECT = correccion(IMG_FLAIR)
  }
  
  ###REGISTRO+EXTRACCIÓN
  #Registramos la FLAIR
  print("Registrando FLAIR al espacio de la FLAIR del paciente 1")
  if(i==1){
    FLAIR_CORRECT_REGISTERED = FLAIR_CORRECT
  }else{
    FLAIR_CORRECT_REGISTERED = registro(FLAIR_CORRECT)
  }
 
  
  #Registramos la T1
  print("Registrando T1 al espacio de la FLAIR del paciente 1")
  T1_CORRECT_REGISTERED = registro(T1_CORRECT)
  
  ##Extracción
  print("Extrayendo Cerebro de FLAIR")
  Si_FLAIR_BRAIN_REGISTERED=mask_img(FLAIR_CORRECT_REGISTERED$outfile,IMG_MASK)
  print("Extrayendo cerebro de la T1")
  Si_T1_BRAIN_REGISTERED = mask_img(T1_CORRECT_REGISTERED$outfile,IMG_MASK)
  
  ##NORMALIZACIÓN
  ##
  ind_f=whitestripe(img = Si_FLAIR_BRAIN,type = "FA",stripped = TRUE)$whitestripe.ind
  ws_flair = whitestripe_norm(Si_FLAIR_BRAIN,indices = ind_f)
  ##
  ind = whitestripe(img = Si_T1_BRAIN,type = "T1",stripped = TRUE)$whitestripe.ind
  ws_t1 = whitestripe_norm(Si_T1_BRAIN,indices = ind)
  
  ###ESCRITURA
  setwd("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES")
  print("Escribiendo Imágenes en la carpeta BRAIN_IMAGES")
  write_nifti(ws_flair,paste0("S",i,"_FLAIR_BRAIN"))
  write_nifti(ws_t1,paste0("S",i,"_T1_BRAIN"))
  BRAIN_FLAIR_path=file.path("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/",paste0("S",i,"_FLAIR_BRAIN.nii.gz"))
  BRAIN_T1_path=file.path("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/",paste0("S",i,"_T1_BRAIN.nii.gz"))
  lB_FLAIR=c(lB_FLAIR,BRAIN_FLAIR_path)
  lB_T1=c(lB_T1,BRAIN_T1_path)
}
IMG_consensus = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","consensus",4)
Si_FLAIR_BRAIN = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/","FLAIR_BRAIN",4)
Si_T1_BRAIN = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/","T1_BRAIN",4)

BRAINS_T1=lapply(lB_T1,readnii)
BRAINS_FLAIR=lapply(lB_FLAIR,readnii)
##Normalizado
ind = whitestripe(img = S1_T1_BRAIN,type = "T1",stripped = TRUE)$whitestripe.ind
ws_t1 = whitestripe_norm(S1_T1_BRAIN,indices = ind)

##
t1_normalizada_zs = zscore_img(S1_T1_BRAIN,IMG_MASK)
##
flair_normalizada_zs = zscore_img(copia_FLAIR,IMG_MASK)
##Simetria
ants_S1_FLAIR_BRAIN=antsImageRead("S1_FLAIR_BRAIN.nii.gz")
asym = reflectImage(ants_S1_FLAIR_BRAIN,1,"AffineFast")$warpedmovout
asimetria = ants_S1_FLAIR_BRAIN-asym
#Acceso a voxel hypercubico
centro = dim(ants_S1_FLAIR_BRAIN)/2
radio = rep(1,3)
cubo = getNeighborhoodAtVoxel(ants_S1_FLAIR_BRAIN,center = centro,radio)

double_ortho(robust_window(readnii("S1_T1_BRAIN")))
#imagenesCorrecion<-correccion(T1)
#double_ortho(T1,imagenesCorrecion)
#WOBABCT1<-fslbet(imagenesCorrecion)
#ortho2(imagenesCorrecion,WOBABCT1, col = "blue")
#reg = extrantsr::registration(filename = FLAIR,template.file = T1,typeofTransform = "Affine",interpolator = "Linear",verbose = FALSE)
#registro full de todas la imgs
T1_imgs = lapply(lT1,readnii)
#T1_imgs_correc=lapply(T1_imgs,correccion)
#no podemos ver las dos imágenes del sujeto 1 simultaneamente debido a que no tienen la misma dimesion

FLAIR_imgs = lapply(lFLAIR,readnii)
FLAIR_S1_Corregida=correccion(FLAIR_imgs[[1]])
#FLAIR_imgs_correc=lapply(FLAIR_imgs,correccion)
#la función registro, realiza un registro de la imágen que se le pasa como argumento respecto a la imagen FLAIR del sujeto 1.
#T1_S1_registrada_F1 = registro(T1_imgs[[1]])
#T1_reg_prueba = lapply(T1_imgs_correc,registro)
#T1_S1_registrada_F1_Corregida=registro(T1_imgs[[1]])
T1_S1_CORREGIDA = correccion(T1_imgs[[1]])
#Leemos las mascaras
Brain_masks=lapply(lBMASK,readnii)
S1_T1_BRAIN = mask_img(img=T1_S1_CORREGIDA,Brain_masks[[1]])
#la mascara y la T1 no tienen las mismas dimensiones
S1_FLAIR_BRAIN = mask_img(FLAIR_S1_Corregida,Brain_masks[[1]])
ortho2(FLAIR_S1_Corregida,S1_FLAIR_BRAIN)
#la máscara con fslbet es peor que utilizando la que viene dada por la fuente
#mask_flair=fslbet(FLAIR_S1_Corregida)
#ortho2(FLAIR_S1_Corregida,mask_flair)
S1_T1_BRAIN=mask_img(T1_S1_registrada_F1_Corregida$outfile,Brain_masks[[1]])
ortho2(T1_S1_registrada_F1_Corregida$outfile,S1_T1_BRAIN)
#En el directorio que queramos, guardamos las imágenes del cerebro extraido.
write_nifti(nim=S1_FLAIR_BRAIN,filename = "S1_FLAIR_BRAIN")
write_nifti(nim=S1_T1_BRAIN,filename = "S1_T1_BRAIN")
##TISSUE SEGMENTATION

##NORMALIZATION

