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