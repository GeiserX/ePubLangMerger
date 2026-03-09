#!/usr/bin/env Rscript
#
# CLI script for merging two epub files (same book, different languages).
# Usage: Rscript script.R <input_dir> <file1.epub> <file2.epub> <output_dir>
#
# Rcompression library: devtools::install_github("omegahat/Rcompression")

source("utils.R")

# -- Argument parsing ----------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 4) {
  cat("Usage: Rscript script.R <input_dir> <file1.epub> <file2.epub> <output_dir>\n")
  cat("  input_dir  - directory containing the two epub files\n")
  cat("  file1.epub - first language epub filename\n")
  cat("  file2.epub - second language epub filename\n")
  cat("  output_dir - directory where the merged epub will be written\n")
  quit(status = 1)
}

input_dir  <- args[1]
file1_name <- args[2]
file2_name <- args[3]
output_dir <- args[4]

# -- Derive filenames ----------------------------------------------------------

archivoFINAL <- deriveOutputName(file1_name, file2_name)
archivoFINALepub <- paste0(archivoFINAL, ".epub")

# -- Extract the epub ZIP files ------------------------------------------------

epub1_path <- file.path(input_dir, file1_name)
epub2_path <- file.path(input_dir, file2_name)

work_dir <- tempdir()
epub1_dir <- file.path(work_dir, gsub("\\.epub$", "", file1_name))
epub2_dir <- file.path(work_dir, gsub("\\.epub$", "", file2_name))

unzip(epub2_path, exdir = epub2_dir)
unzip(epub1_path, exdir = epub1_dir)

# -- Parse XHTML files from the second-language epub ---------------------------

dirs2 <- dir(path = file.path(epub2_dir, "OEBPS"), pattern = "\\.xhtml$")
full_paths2 <- file.path(epub2_dir, "OEBPS", dirs2)
current2 <- sapply(full_paths2, function(f) xmlRoot(htmlParse(f)))

# -- Parse XHTML files from the first-language epub ----------------------------

dirs1 <- dir(path = file.path(epub1_dir, "OEBPS"), pattern = "\\.xhtml$")
full_paths1 <- file.path(epub1_dir, "OEBPS", dirs1)
current1 <- sapply(full_paths1, function(f) xmlRoot(htmlParse(f)))

# -- Merge second-language content as siblings ---------------------------------

for (k in seq_along(current1)) {
  for (tag in c("p", "h1", "h2", "h3", "h4", "h5")) {
    nodes2 <- xpathSApply(current2[[k]], paste0("//", tag))
    nodes1 <- xpathSApply(current1[[k]], paste0("//", tag))
    makeSibling(nodes1, nodes2)
  }
}

# -- Save merged content into a new directory ----------------------------------

merged_dir <- file.path(work_dir, archivoFINAL)
if (dir.exists(merged_dir)) unlink(merged_dir, recursive = TRUE)
dir.create(merged_dir)

# Copy all contents from the first-language epub directory
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

# -- Create the merged epub (zip) ----------------------------------------------

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
output_path <- file.path(output_dir, archivoFINALepub)
if (file.exists(output_path)) file.remove(output_path)

old_wd <- setwd(merged_dir)
on.exit(setwd(old_wd), add = TRUE)
Rcompression::zip(zipfile = output_path, files = list.files(recursive = TRUE))
setwd(old_wd)

cat("Created:", output_path, "\n")
