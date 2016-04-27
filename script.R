library(XML)

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

###########################
## Inicializamos valores ##
###########################

directorioPrincipal <- "/home/sergio/Escritorio/epub-lang-merger"
archivo1 <- "w_S_20150915"
archivo2 <- "w_BL_20150915"
archivoFINAL <- "w_S_BL_20150915"

archivoDIR1 <- paste0("/", archivo1)
archivoDIR2 <- paste0("/", archivo2)
directorioPrincipalData <- paste0(directorioPrincipal, "/data")
archivoEPUB1 <- paste0(archivoDIR1, ".epub")
dirDataEPub1 <- paste0("data", archivoEPUB1)
dirData1 <- paste0("data", archivoDIR1)
archivoEPUB2 <- paste0(archivoDIR2, ".epub")
dirDataEPub2 <- paste0("data", archivoEPUB2)
dirData2 <- paste0("data", archivoDIR2)
archivoEPUBfinal <- paste0(archivoFINAL, ".epub")

##############################
## Extraemos los ZIP (ePub) ##
##############################

setwd(directorioPrincipal)
unzip(dirDataEPub2, exdir = dirData2)
unzip(dirDataEPub1, exdir = dirData1)

###########################################################################
## Extraemos todos los ficheros XHTML dentro del ePub del segundo idioma ##
###########################################################################

setwd(paste0(dirData2, "/OEBPS"))
dirs2 <- dir(pattern = ".xhtml$")
current2 <- sapply(dirs2, htmlParse)
current2 <- sapply(current2, xmlRoot)

##########################################################################
## Extraemos todos los ficheros XHTML dentro del ePub del primer idioma ##
##########################################################################

setwd(".."); setwd(".."); setwd("..");
setwd(paste0(dirData1, "/OEBPS"))
dirs1 <- dir(pattern = ".xhtml$")
current1 <- sapply(dirs1, htmlParse)
current1 <- sapply(current1, xmlRoot)

###############################################################################################################
## Buscamos y cambiamos atributo ID del segundo idioma para cada documento. También lo añadimos como Sibling ##
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

####################################
## Guardamos en una nueva carpeta ##
####################################

setwd("..")
dir <- dir()
setwd("..")
# Para borrar:
if(dir.exists(archivoFINAL)) unlink(archivoFINAL, recursive = TRUE)
dir.create(archivoFINAL)
for(l in 1:length(dir)){ # Copiamos desde el directorio del primer idioma
  file.copy(from = paste0(paste0(archivo1, "/"), dir[l]), to = paste0(archivoFINAL, "/"), recursive = TRUE)
}
setwd(paste0(archivoFINAL, "/OEBPS"))

for(z in 1:length(dirs1)){ # Sobreescribimos con el nuevo archivo
  
  saveXML(doc = current1[[z]], file = dirs1[z], prefix = '<?xml version="1.0" encoding="utf-8" ?>\n')
  
  #   sink(dirs1[z])
  #   print(current1[[z]])
  #   #cat(capture.output(current1[[z]])[-1], sep = "\n")
  #   sink()
  
}

######################
## Cambiamos título ##
######################


##################
## Creamos ePub ##
##################

setwd("..")
dirs <- list.files(recursive = T)
# Para borrar

if(file.exists(paste(directorioPrincipalData, archivoEPUBfinal, sep = "/"))) file.remove(paste(directorioPrincipalData, archivoEPUBfinal, sep = "/"))
Rcompression::zip(zipfile = paste(directorioPrincipalData, archivoEPUBfinal, sep = "/"), files = dirs)
# Rcompression library devtools::install_github("omegahat/Rcompression")
