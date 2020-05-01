source("correccion.R")
source("leeImagen.R")
source("registro.R")
source("registroMascara.R")
library(neurobase)
library(ANTsR)
library(extrantsr)
#Configuración del registro
s1_FLAIR_CORRECTED=correccion(readnii("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_FLAIR.nii.gz"))
S1_MASK = readnii("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_brainmask.nii.gz")

#PARA MI DATASET DE MRI APLICAREMOS LA SIGUIENTE SECUENCIA DE PASOS
for (i in 2:30){
  ###LECTURA
  if(i == 1){
    IMG_MASK = S1_MASK
  }
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
    #registro flair
    mascara = IMG_MASK
  }else{
    FLAIR_CORRECT_REGISTERED = registro(FLAIR_CORRECT)$outfile
    #registro mascara
    print("Registrando la Máscara al espacio de la Máscara del paciente 1")
    NEW_MASK = registroMascara(IMG_MASK)$outfile
    mascara  = array(as.integer(c(NEW_MASK)),dim = dim(NEW_MASK))
  }
  #Registramos la T1
  print("Registrando T1 al espacio de la FLAIR del paciente 1")
  T1_CORRECT_REGISTERED = registro(T1_CORRECT)$outfile
  #registramos la máscara

  ##Extracción
  print("Extrayendo Cerebro de FLAIR")
  Si_FLAIR_BRAIN_REGISTERED=mask_img(FLAIR_CORRECT_REGISTERED,mascara)
  print("Extrayendo cerebro de la T1")
  Si_T1_BRAIN_REGISTERED = mask_img(T1_CORRECT_REGISTERED,mascara)
  
  ##NORMALIZACIÓN
  ##
  ws_flair =zscore_img(Si_FLAIR_BRAIN_REGISTERED)
  ##
  ws_t1 = zscore_img(Si_T1_BRAIN_REGISTERED)
  
  
  ###ESCRITURA
  print("Escribiendo Imágenes en la carpeta BRAIN_IMAGES")
  write_nifti(ws_flair,paste0("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/","S",i,"_FLAIR_BRAIN"))
  write_nifti(ws_t1,paste0("/Users/juanjoseruizpenela/Documents/IMG1/BRAIN_IMAGES/","S",i,"_T1_BRAIN"))
}


