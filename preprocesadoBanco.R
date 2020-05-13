source("correccion.R")
source("leeImagen.R")
source("registro.R")
source("registroMascara.R")
library(neurobase)
library(ANTsR)
library(extrantsr)
#Configuración del registro
s1_FLAIR_CORRECTED=correccion(antsImageRead("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_FLAIR.nii.gz"))
S1_MASK = antsImageRead("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/patient1_brainmask.nii.gz")

#PARA MI DATASET DE MRI APLICAREMOS LA SIGUIENTE SECUENCIA DE PASOS
for (i in 1:30){
  ###LECTURA
  if(i == 1){
    IMG_MASK = S1_MASK
  }
  print(paste0("Leyendo Imagen T1 del sujeto ",i))
  print(paste0("Leyendo Imagen FLAIR del sujeto ",i))
  print(paste0("Leyendo Máscara del sujeto ",i))

  IMG_FLAIR = antsImageRead(paste0("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","patient",i,"_FLAIR.nii.gz"))
  IMG_T1 = antsImageRead(paste0("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","patient",i,"_T1W.nii.gz"))
  IMG_MASK = antsImageRead(paste0("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","patient",i,"_brainmask.nii.gz"))
  IMG_CONSENSO = antsImageRead(paste0("/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","patient",i,"_consensus_gt.nii.gz"))
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
  wtx = antsRegistration(s1_FLAIR_CORRECTED,FLAIR_CORRECT,typeofTransform = "AffineFast")
  wtt1 = antsRegistration(s1_FLAIR_CORRECTED,T1_CORRECT,typeofTransform = "AffineFast")
  wtmask = antsRegistration(S1_MASK,IMG_MASK,typeofTransform = "AffineFast")
    
  FLAIR_CORRECT_REGISTERED = antsApplyTransforms(s1_FLAIR_CORRECTED,FLAIR_CORRECT,transformlist = wtx$fwdtransforms)
  NEW_MASK = antsApplyTransforms(S1_MASK,IMG_MASK,transformlist = wtmask$fwdtransforms)
  T1_CORRECT_REGISTERED = antsApplyTransforms(s1_FLAIR_CORRECTED,T1_CORRECT,transformlist = wtt1$fwdtransforms)
  CONSENSO_REGISTERED = antsApplyTransforms(s1_FLAIR_CORRECTED,IMG_CONSENSO,transformlist = wtx$fwdtransforms)
    #registro mascara
    #print("Registrando la Máscara al espacio de la Máscara del paciente 1")
    #mascara  = array(as.integer(c(NEW_MASK)),dim = dim(NEW_MASK))
    
  
  ##Extracción
  print("extrayendo t1")
  print("Extrayendo Cerebro de FLAIR")
  Si_FLAIR_BRAIN_REGISTERED = maskImage(FLAIR_CORRECT_REGISTERED,NEW_MASK)
  print("Extrayendo cerebro de la T1")
  Si_T1_BRAIN_REGISTERED = maskImage(T1_CORRECT_REGISTERED,NEW_MASK)
  
  

  ##NORMALIZACIÓN
  ##
  ws_flair =zscore_img(Si_FLAIR_BRAIN_REGISTERED)
  ##
  ws_t1 = zscore_img(Si_T1_BRAIN_REGISTERED)
  
  
  ###ESCRITURA
  print("Escribiendo Imágenes en la carpeta BRAIN_IMAGES")
  writenii(ws_flair,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",i,"_FLAIR_BRAIN"))
  writenii(ws_t1,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",i,"_T1_BRAIN"))
  antsImageWrite(CONSENSO_REGISTERED,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",i,"_CONSENSO.nii.gz"))
}
##registro consensos
for(j in 1:30){
  consensoj = leeImagen(ROOT = "/Users/juanjoseruizpenela/Documents/IMG1/raw_images/","consensus",j)
  if(j==1){
    consenso_regist = consensoj
  }else{
    consenso_regist = registro(consensoj)$outfile
  }
  print("escribiendo")
  writenii(consenso_regist,paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",j,"_CONSENSO"))
}

##control de calidad manual
k = 0

k=k+1
consensoi = readnii(paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/CONSENSO/","S",k,"_CONSENSO.nii.gz"))
flair_braini=readnii(paste0("/Users/juanjoseruizpenela/Documents/GIT REPOSITORY/myrepo/BRAIN_IMAGES/","S",k,"_FLAIR_BRAIN.nii.gz"))
ortho2(flair_braini,consensoi)
k
