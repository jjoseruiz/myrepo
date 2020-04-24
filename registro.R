registro<-function(IMG){
  print("Ejecución Registro")
  reg = extrantsr::registration(filename = IMG,template.file = s1_FLAIR_CORRECTED,correct = FALSE, typeofTransform = "AffineFast",interpolator = "Linear",verbose = FALSE)
  print("FIN DEL REGISTRO")
  return (reg)
}