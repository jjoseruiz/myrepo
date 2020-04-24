correccion<-function(IMG){
  IMG[IMG<0]=0
  print("Correcion N3")
  #Aplicamos homgenización de la imagen para evitar artefactor como sombras.
  bf_t1=extrantsr::bias_correct(file=IMG,correction = "N3")
  print("correccion finalizada")
  return (IMG)
}