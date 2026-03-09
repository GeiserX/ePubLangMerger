library(XML)

#' Merge matching XML nodes from doc2 into doc1 as siblings,
#' renaming duplicate IDs in the second-language nodes.
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

#' Derive merged filename from two epub filenames.
#' Expects format: Title_LangCode.epub (e.g., MyBook_EN.epub)
deriveOutputName <- function(name1, name2) {
  base1 <- gsub("\\.epub$", "", name1, ignore.case = TRUE)
  base2 <- gsub("\\.epub$", "", name2, ignore.case = TRUE)
  parts1 <- unlist(strsplit(base1, "_"))
  parts2 <- unlist(strsplit(base2, "_"))

  if (length(parts1) == 2) {
    paste(parts1[1], parts1[2], parts2[2], sep = "_")
  } else if (length(parts1) == 3) {
    paste(parts1[1], parts1[2], parts2[2], parts1[3], sep = "_")
  } else {
    paste0(base1, "_merged")
  }
}
