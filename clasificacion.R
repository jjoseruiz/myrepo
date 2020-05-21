necesarios=c("tree","rpart","rpart.plot","dplyr","randomForest")
install.packages(necesarios,dependencies = TRUE,repos = "http://cran.us.r-project.org")
library(tree)
library(rpart)
library(rpart.plot)
library(dplyr)
library(randomForest)
dataset<-read.csv("almacen")
dataset<-dataset[,2:ncol(dataset)]
<<<<<<< HEAD
nombrecolumnas = c("MEAN_FLAIR","MIN_FLAIR","MAX_FLAIR","SD_FLAIR","MEAN_T1","MIN_T1","MAX_T1","SD_T1","LESION")
colnames(dataset)<-nombrecolumnas
lesion=filter(dataset,LESION==1)
dataset$LESION=factor(dataset$LESION)
set.seed(1924562)
#creamos la partición
=======
lesion=filter(dataset,LESION==1)
dataset$LESION=factor(dataset$LESION)
set.seed(1924562)
>>>>>>> cfabab5240d4a0054f4dfd35b27e9a8e68859ce5
particion=runif(nrow(dataset))
entrenamiento=dataset[particion<0.85,]
prueba=dataset[particion>=0.85,]
modelo = randomForest(LESION~.,data=entrenamiento,na.action = na.omit,ntree=300)
modelo$confusion
prediccion=predict(modelo,prueba)
mc_rf=table(prediccion,prueba$LESION)
exac=sum(diag(mc_rf))/sum(mc_rf)
exac
<<<<<<< HEAD
arbol = randomForest::getTree(modelo)
#para escribir el modelo
saveRDS(modelo,"modelo.rds")
=======

>>>>>>> cfabab5240d4a0054f4dfd35b27e9a8e68859ce5
library(caret)
trainData=dataset[,1:(ncol(dataset)-1)]
trainClase=dataset[,ncol(dataset)]
knn=train(trainData,trainClase,method = "knn",preProcess = c("center","scale"),tuneLength = 10,trControl = trainControl(method="cv"))
<<<<<<< HEAD
knn$results
knn$preProcess
knn$perfNames
caret::confusionMatrix(knn)
=======
>>>>>>> cfabab5240d4a0054f4dfd35b27e9a8e68859ce5
