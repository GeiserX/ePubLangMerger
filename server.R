# shiny::runApp('/home/drumsergio/EpubMerger', port=8080, host='0.0.0.0', launch.browser=F)

library(shiny)
library(XML)
library(stringr)
library(readr)

makeSibling <- function(parrafos1, parrafos2){
  if(length(parrafos1) != 0){
    parrafoSHORT <- if(length(parrafos1) >= length(parrafos2)) length(parrafos2) else length(parrafos1)
    for(i in 1:parrafoSHORT){
      print(i)
      for(j in 1:length(xmlAttrs(parrafos2[[i]]))){
        print(j)
        if(!is.null(xmlAttrs(parrafos2[[i]])[[j]]) && (names(xmlAttrs(parrafos2[[i]]))[j] == "id")){
          xmlAttrs(parrafos2[[i]])[[j]] <- paste0(xmlAttrs(parrafos2[[i]])[[j]], "_2")
        }
      }
      addSibling(parrafos1[[i]], parrafos2[[i]])
    }
  }
}

shinyServer(function(input, output) {

  observeEvent(input$submit, {
    if(is.null(input$epub1) || is.null(input$epub2)) return()

    #############################################
    ## Construimos el nombre del archivo final ##
    #############################################
    archivo1 <- str_split(gsub('.{5}$', '', input$epub1$name), "_")
    archivo2 <- str_split(gsub('.{5}$', '', input$epub2$name), "_")
    if(length(archivo1[[1]]) == 2){
      archivoFINAL <- paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], sep = "_")
      archivoFINALepub <- paste(paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], sep = "_"), "epub", sep = ".")
    } else if(length(archivo1[[1]]) == 3){
      archivoFINAL <- paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], archivo1[[1]][3], sep = "_")
      archivoFINALepub <- paste(paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], archivo1[[1]][3], sep = "_"), "epub", sep = ".")
    }
    print(paste0("Name: ", archivoFINALepub))
    
    #################################################
    ## Comprobamos que el archivo no este hecho ya ##
    #################################################
    if(file.exists(paste0("/home/drumsergio/EpubMerger/files/", archivoFINALepub))){
      output$descargaUI <- renderUI({ downloadButton(outputId = 'descargaSR', label =  'Download') })
      output$descargaSR <- downloadHandler(
        filename = function() { archivoFINALepub }, 
        content = function(file) {
          write(read_file(paste0("/home/drumsergio/EpubMerger/files/", archivoFINALepub)), file)
        }
      )
      return()
    }
    
    ##############################
    ## Extraemos los ZIP (ePub) ##
    ##############################
    unzip(input$epub1$datapath, exdir = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub1$name)))
    unzip(input$epub2$datapath, exdir = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub2$name)))
    print("Unzip OK")
    
    ###########################################################################
    ## Extraemos todos los ficheros XHTML dentro del ePub del segundo idioma ##
    ###########################################################################
    dirs2 <- dir(path = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub2$name), "/OEBPS"), pattern = ".xhtml$")
    print("Begin parsing")
    #suppressWarnings({
      current2 <- sapply(dirs2, htmlParse, asText = T)
      current2 <- sapply(current2, xmlRoot)
    #})
    print("Extraction dir2 OK")
    
    ##########################################################################
    ## Extraemos todos los ficheros XHTML dentro del ePub del primer idioma ##
    ##########################################################################
    dirs1 <- dir(path = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub1$name), "/OEBPS"), pattern = ".xhtml$")
    current1 <- sapply(dirs1, htmlParse, asText = T)
    current1 <- sapply(current1, xmlRoot)
    print("Extraction dir1 OK")
    
    ###############################################################################################################
    ## Buscamos y cambiamos atributo ID del segundo idioma para cada documento. Tambien lo anadimos como Sibling ##
    ###############################################################################################################
    for(k in 1:length(current1)){
      parrafos2 <- xpathSApply(current2[[k]], "//p")
      parrafos1 <- xpathSApply(current1[[k]], "//p")
      makeSibling(parrafos1, parrafos2)
      
      parrafos2 <- xpathSApply(current2[[k]], "//h1")
      parrafos1 <- xpathSApply(current1[[k]], "//h1")
      makeSibling(parrafos1, parrafos2)
      
      parrafos2 <- xpathSApply(current2[[k]], "//h2")
      parrafos1 <- xpathSApply(current1[[k]], "//h2")
      makeSibling(parrafos1, parrafos2)
      
      parrafos2 <- xpathSApply(current2[[k]], "//h3")
      parrafos1 <- xpathSApply(current1[[k]], "//h3")
      makeSibling(parrafos1, parrafos2)
      
      parrafos2 <- xpathSApply(current2[[k]], "//h4")
      parrafos1 <- xpathSApply(current1[[k]], "//h4")
      makeSibling(parrafos1, parrafos2)
      
      parrafos2 <- xpathSApply(current2[[k]], "//h5")
      parrafos1 <- xpathSApply(current1[[k]], "//h5")
      makeSibling(parrafos1, parrafos2)
    }
    print("MakeSibling OK")
    
    ######################################################
    ## Guardamos en una nueva carpeta y sobreescribimos ##
    ######################################################
    dir.create(paste0("/home/drumsergio/EpubMerger/files/", archivoFINAL))
    dir <- dir(path = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub1$name)))
    for(l in 1:length(dir)){ # Copiamos desde el directorio del primer idioma
      file.copy(from = paste0("/home/drumsergio/EpubMerger/files/", gsub('.{5}$', '', input$epub1$name), '/', dir[l]),
                to = paste0("/home/drumsergio/EpubMerger/files/", archivoFINAL, "/"), recursive = TRUE)
    }
    for(z in 1:length(dirs1)){ # Sobreescribimos con el nuevo archivo
      saveXML(doc = current1[[z]], file = paste0("/home/drumsergio/EpubMerger/files/", archivoFINAL, "/OEBPS/", dirs1[z]),
              prefix = '<?xml version="1.0" encoding="utf-8" ?>\n')
    }
    print("Dir Creation OK, Now compressing...")
    
    ###############################
    ## Cambiamos titulo del ePub ##
    ###############################
    
    ##################
    ## Creamos ePub ##
    ##################
    Rcompression::zip(zipfile = paste0("/home/drumsergio/EpubMerger/files/", archivoFINALepub), 
                      files = list.files(path = paste0("/home/drumsergio/EpubMerger/files/", archivoFINAL), recursive = T))
    print("Compression finished")
    
    output$descarga <- downloadHandler(
      filename = function() { archivoFINALepub },
      content = function(file) {
        file.copy(paste0("/home/drumsergio/EpubMerger/files/", archivoFINALepub), file)
      }
    )
  })
  
})