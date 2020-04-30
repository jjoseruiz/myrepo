registroMascara<-function(MASCARA)
{
  print("Ejecución Registro")
  reg = extrantsr::registration(filename = MASCARA,template.file = S1_MASK,correct = FALSE, typeofTransform = "AffineFast",interpolator = "Linear",verbose = FALSE)
  print("FIN DEL REGISTRO")
  return (reg)
}