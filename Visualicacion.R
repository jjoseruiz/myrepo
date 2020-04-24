#Visualization
fpath<-file.path(getwd(),paste0("Documents/","IMG1/","patient01-05/","patient01/","patient01_","FLAIR",".nii.gz"))
f1 =neurobase::readnii(fpath)
f1
plot(density(f1))
#observamos gran densidad en 0, la cual se corresponden con el fondo de la imagen.
plot(density(f1,mask = f1>0))
#realizamos un histograma quitando los 0
hist(f1[f1>0])
#display la imagen nifti en 3 planos
neurobase::ortho2(f1)
#para aclarar la imagen
neurobase::ortho2(robust_window(f1,probs = c(0,0.975)))
#función de densidad de la imagen 
plot(density(robust_window(f1,probs = c(0,0.975))))
#visualizamos la flair con una mascara de valores superiores a 200
neurobase::ortho2(f1,y = f1>300)
#para representar varias imagenes a la vez
neurobase::double_ortho(f1, y=f1>100, col.y = "white")
oro.nifti::image(f1,useRaster = TRUE)
#podemos visualizar capas por capas slice. axial
oro.nifti::slice(f1,z=c(150,170,190,210,230,250,270,300))
#sagital
oro.nifti::slice(f1,z=c(10,20,40,60,80,100,120,140),plane = "sagittal")
#aplicar filtor gausiano
sm_img = extrantsr::smooth_image(f1,sigma=2)
double_ortho(f1,sm_img)
##TISSUE SEGMENTATION
library(ms.lesion)
library(neurobase)
all_files = get_image_filenames_list_by_subject(group = "training", type = "coregistered")
files = all_files$training02 
t1 = readnii(files["T1"])
mask = readnii(files["Brain_Mask"])
hist(t1, mask = mask, breaks = 2000);text(x = 600, y = 40000, '"outliers"')
hist(S1_FLAIR_BRAIN)
t1_otropos = otropos(a = t1, x = mask) # using original data
t1seg = t1_otropos$segmentation
ortho2(t1, t1seg == 3,text = "White Matter")