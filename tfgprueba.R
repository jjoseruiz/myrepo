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


