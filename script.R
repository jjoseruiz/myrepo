t1 = readnii("patient01_FLAIR.nii")
class(t1)
t1_copy = t1
t1_copy[t1_copy>250]=250
max(t1_copy)
max(t1)
writenii(nim = t1_copy,filename = "patient01_FLAIR_UNDER250.nii")
file.exists("patient01_FLAIR_UNDER250.nii.gz")
#pasar un nifti a un vector
vals = c(t1)
#dataframed
df=data.frame(t1=c(t1),mask =c(t1>250))
#acceso a archivos
x=file.path("/Users/juanjoseruizpenela/Documents/WORKSPACE",paste0("img",".nii.gz"))
x
