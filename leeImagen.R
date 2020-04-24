leeImagen<-function(ROOT,MODALIDAD,SUJETO)
{
  print(paste0(ROOT,MODALIDAD,"/SUJETO",SUJETO))
  if(MODALIDAD == "T1"){
    ruta=file.path(ROOT,paste0("patient",SUJETO,"_",MODALIDAD,"W.nii.gz" ))
  }else if(MODALIDAD == "FLAIR"){
    ruta=file.path(ROOT,paste0("patient",SUJETO,"_",MODALIDAD,".nii.gz" ))
  }else if(MODALIDAD == "brainmask"){
    ruta=file.path(ROOT,paste0("patient",SUJETO,"_",MODALIDAD,".nii.gz" ))
  }else if(MODALIDAD =="consensus"){
    ruta=file.path(ROOT,paste0("patient",SUJETO,"_",MODALIDAD,"_gt.nii.gz" ))
  }else if(MODALIDAD == "FLAIR_BRAIN"){
    ruta=file.path(ROOT,paste0("S",SUJETO,"_",MODALIDAD,".nii.gz" ))
  }else if(MODALIDAD == "T1_BRAIN"){
    ruta=file.path(ROOT,paste0("S",SUJETO,"_",MODALIDAD,".nii.gz" ))
  }
  imagen = readnii(ruta)
  return (imagen)
}