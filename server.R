library(shiny)
library(XML)
library(stringr)

# Merge matching XML nodes from doc2 into doc1 as siblings,
# renaming duplicate IDs in the second-language nodes.
makeSibling <- function(nodes1, nodes2) {
  if (length(nodes1) == 0) return()
  n <- min(length(nodes1), length(nodes2))
  for (i in seq_len(n)) {
    attrs <- xmlAttrs(nodes2[[i]])
    for (j in seq_along(attrs)) {
      if (!is.null(attrs[[j]]) && (names(attrs)[j] == "id")) {
        xmlAttrs(nodes2[[i]])[[j]] <- paste0(attrs[[j]], "_2")
      }
    }
    addSibling(nodes1[[i]], nodes2[[i]])
  }
}

shinyServer(function(input, output, session) {

  # Session-specific temporary directory for all file operations
  files_dir <- file.path(tempdir(), paste0("epubmerger_", session$token))
  dir.create(files_dir, showWarnings = FALSE, recursive = TRUE)

  # Clean up temp files when session ends
  session$onSessionEnded(function() {
    unlink(files_dir, recursive = TRUE)
  })

  observeEvent(input$submit, {
    if (is.null(input$epub1) || is.null(input$epub2)) return()

    # Validate file extensions
    if (!grepl("\\.epub$", input$epub1$name, ignore.case = TRUE) ||
        !grepl("\\.epub$", input$epub2$name, ignore.case = TRUE)) {
      showNotification("Both files must be .epub format.", type = "error")
      return()
    }

    tryCatch({
      # Build the final filename from the input names
      archivo1 <- str_split(gsub('.{5}$', '', input$epub1$name), "_")
      archivo2 <- str_split(gsub('.{5}$', '', input$epub2$name), "_")
      if (length(archivo1[[1]]) == 2) {
        archivoFINAL <- paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], sep = "_")
      } else if (length(archivo1[[1]]) == 3) {
        archivoFINAL <- paste(archivo1[[1]][1], archivo1[[1]][2], archivo2[[1]][2], archivo1[[1]][3], sep = "_")
      } else {
        archivoFINAL <- paste0(gsub('.{5}$', '', input$epub1$name), "_merged")
      }
      archivoFINALepub <- paste0(archivoFINAL, ".epub")

      # Check if the file was already generated in this session
      cached_path <- file.path(files_dir, archivoFINALepub)
      if (file.exists(cached_path)) {
        output$descargaUI <- renderUI({
          downloadButton(outputId = 'descargaSR', label = 'Download')
        })
        output$descargaSR <- downloadHandler(
          filename = function() { archivoFINALepub },
          content = function(file) {
            file.copy(cached_path, file)
          }
        )
        return()
      }

      showNotification("Processing epubs...", type = "message", id = "progress")

      # Extract the epub ZIP files
      epub1_name <- gsub('.{5}$', '', input$epub1$name)
      epub2_name <- gsub('.{5}$', '', input$epub2$name)
      epub1_dir <- file.path(files_dir, epub1_name)
      epub2_dir <- file.path(files_dir, epub2_name)
      unzip(input$epub1$datapath, exdir = epub1_dir)
      unzip(input$epub2$datapath, exdir = epub2_dir)

      # Parse all XHTML files from the second-language epub
      dirs2 <- dir(path = file.path(epub2_dir, "OEBPS"), pattern = "\\.xhtml$")
      full_paths2 <- file.path(epub2_dir, "OEBPS", dirs2)
      current2 <- sapply(full_paths2, function(f) xmlRoot(htmlParse(f)))

      # Parse all XHTML files from the first-language epub
      dirs1 <- dir(path = file.path(epub1_dir, "OEBPS"), pattern = "\\.xhtml$")
      full_paths1 <- file.path(epub1_dir, "OEBPS", dirs1)
      current1 <- sapply(full_paths1, function(f) xmlRoot(htmlParse(f)))

      # Merge second-language content as siblings of the first-language nodes
      for (k in seq_along(current1)) {
        for (tag in c("p", "h1", "h2", "h3", "h4", "h5")) {
          nodes2 <- xpathSApply(current2[[k]], paste0("//", tag))
          nodes1 <- xpathSApply(current1[[k]], paste0("//", tag))
          makeSibling(nodes1, nodes2)
        }
      }

      # Create merged output directory, copying from the first-language epub
      merged_dir <- file.path(files_dir, archivoFINAL)
      dir.create(merged_dir, showWarnings = FALSE)
      epub1_contents <- dir(path = epub1_dir)
      for (item in epub1_contents) {
        file.copy(
          from = file.path(epub1_dir, item),
          to = file.path(merged_dir, ""),
          recursive = TRUE
        )
      }

      # Overwrite XHTML files with the merged content
      for (z in seq_along(dirs1)) {
        saveXML(
          doc = current1[[z]],
          file = file.path(merged_dir, "OEBPS", dirs1[z]),
          prefix = '<?xml version="1.0" encoding="utf-8" ?>\n'
        )
      }

      # Create the epub (zip). Rcompression::zip needs files relative to cwd.
      old_wd <- setwd(merged_dir)
      on.exit(setwd(old_wd), add = TRUE)
      Rcompression::zip(
        zipfile = cached_path,
        files = list.files(recursive = TRUE)
      )
      setwd(old_wd)

      removeNotification("progress")
      showNotification("Merge complete! Click Download.", type = "message")

      # Provide the download button and handler
      output$descargaUI <- renderUI({
        downloadButton(outputId = 'descargaSR', label = 'Download')
      })
      output$descargaSR <- downloadHandler(
        filename = function() { archivoFINALepub },
        content = function(file) {
          file.copy(cached_path, file)
        }
      )
    }, error = function(e) {
      removeNotification("progress")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  })
})
