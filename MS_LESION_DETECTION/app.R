#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
# Define UI for application that draws a histogram
ui <- fluidPage(theme=shinytheme("cerulean"),
                titlePanel("Detección de lesiones"),
                navbarPage("MS LESION DETECTION",
                    tabPanel("Inicio",titlePanel("Introducción"),
                             "La Esclerosis Múltiple (MS) es una enfermedad autoinmune que degrada las vainas de mielina de las neuronas del Sistema Nervioso Central, afectado aí a las conexiones nerviosas. 
                             Esto hace que la enfermedad se manifieste en cada persona de manera diferente y con síntomas impredecibles tales como dolores, pérdida de memoria, hormigueo o incluso parálisis. 
                             A pesar de los grandes avances en medicina y tecnología, aún se desconoce el origen de la enfermedad, no obstante, podemos estudiar y diagnosticar si una persona la padece o podrá padecerla en un futuro.
                             ",titlePanel("Aplicación"),
                             "Esta web es una aplicación web basada en modelos de machine learning que utilizan clasificadores con gran reputación como RandomForest, K-nearest-neighbour, otros... para detectar lesiones cerebrales en pacientes con Esclerosis Múltiple.",
                             titlePanel("Flujo de procesos"),
                             "inserto imagen del flujo Prepocesado (correccion + registro + extracción) + construcción modelo + predicción"
                             ),
                    tabPanel("Subir Imagenes",
                             mainPanel(
                                 tags$h1("Sube aquí sus imágenes"),
                                 "Recuerde que sus imágenes deben tener extensión .nii o .nii.gz",
                                 tags$hr(),
                                 fileInput("ImagenFlair","FLAIR", multiple = FALSE, accept = c(".nii",".nii.gz")),
                                 fileInput("ImagenT1","T1", multiple = FALSE, accept = c(".nii",".nii.gz")),
                                 actionLink("gonext","Siguiente paso")                                 
                             ),
                    ),
                    tabPanel("Preprocesado",
                             titlePanel("Descripción"),
                             "Estamos preparando sus imágenes. Esto puede tardar varios minutos.",
                             "aquí pondría alguna señal de por que parte va el procesado de las imágenes/loading correcion n3 90%"),
                    tabPanel("Predicción"),
                    tabPanel("Resultados")),
)

server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        if(!is.nifti(input$ImagenFlair))
            textOutput("no es una")

    })
}

# Run the application 
shinyApp(ui = ui, server = server)
