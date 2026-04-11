library(testthat)

# Source only the deriveOutputName function from utils.R without loading XML.
# The XML package has C-level issues on some CI environments, and deriveOutputName
# is pure R string logic that does not require it.
local({
  lines <- readLines(file.path(Sys.getenv("GITHUB_WORKSPACE", unset = getwd()), "utils.R"))
  # Remove the library(XML) call so we can source the pure-R functions
  lines <- lines[!grepl("^\\s*library\\(XML\\)", lines)]
  eval(parse(text = lines), envir = globalenv())
})

# =============================================================================
# deriveOutputName
# =============================================================================

test_that("deriveOutputName merges two-part filenames (Title_Lang)", {
  result <- deriveOutputName("MyBook_EN.epub", "MyBook_ES.epub")
  expect_equal(result, "MyBook_EN_ES")
})

test_that("deriveOutputName merges three-part filenames (Title_Lang_Extra)", {
  result <- deriveOutputName("MyBook_EN_2024.epub", "MyBook_ES_2024.epub")
  expect_equal(result, "MyBook_EN_ES_2024")
})

test_that("deriveOutputName falls back to _merged for single-part names", {
  result <- deriveOutputName("MyBook.epub", "OtherBook.epub")
  expect_equal(result, "MyBook_merged")
})

test_that("deriveOutputName is case-insensitive for .epub extension", {
  result <- deriveOutputName("MyBook_EN.EPUB", "MyBook_ES.EPUB")
  expect_equal(result, "MyBook_EN_ES")
})

test_that("deriveOutputName handles different language codes", {
  result <- deriveOutputName("Novel_FR.epub", "Novel_DE.epub")
  expect_equal(result, "Novel_FR_DE")
})

test_that("deriveOutputName handles underscores in title for three-part names", {
  result <- deriveOutputName("My_Book_EN.epub", "My_Book_ES.epub")
  expect_equal(result, "My_Book_ES_EN")
})

# =============================================================================
# makeSibling (requires XML package - skip if unavailable or unstable)
# =============================================================================

xml_available <- tryCatch({
  library(XML)
  # Quick sanity test to catch C-level crashes
  doc <- xmlParse("<root><a/></root>")
  free(doc)
  TRUE
}, error = function(e) FALSE)

skip_msg <- "XML package not available or unstable"

test_that("makeSibling inserts nodes from doc2 after nodes in doc1", {
  skip_if_not(xml_available, skip_msg)
  doc1 <- xmlParse('<html><body><p id="a">Hello</p></body></html>')
  doc2 <- xmlParse('<html><body><p id="a">Hola</p></body></html>')
  nodes1 <- xpathSApply(doc1, "//p")
  nodes2 <- xpathSApply(doc2, "//p")
  makeSibling(nodes1, nodes2)
  body_children <- xpathSApply(doc1, "//body/p")
  expect_equal(length(body_children), 2)
  second_id <- xmlGetAttr(body_children[[2]], "id")
  expect_equal(second_id, "a_2")
})

test_that("makeSibling handles empty nodes1 gracefully", {
  skip_if_not(xml_available, skip_msg)
  doc1 <- xmlParse('<html><body></body></html>')
  doc2 <- xmlParse('<html><body><p id="x">Text</p></body></html>')
  nodes1 <- xpathSApply(doc1, "//p")
  nodes2 <- xpathSApply(doc2, "//p")
  expect_silent(makeSibling(nodes1, nodes2))
})

test_that("makeSibling merges min(len1, len2) when counts differ", {
  skip_if_not(xml_available, skip_msg)
  doc1 <- xmlParse('<html><body><p>One</p><p>Two</p><p>Three</p></body></html>')
  doc2 <- xmlParse('<html><body><p>Uno</p><p>Dos</p></body></html>')
  nodes1 <- xpathSApply(doc1, "//p")
  nodes2 <- xpathSApply(doc2, "//p")
  makeSibling(nodes1, nodes2)
  all_p <- xpathSApply(doc1, "//body/p")
  expect_equal(length(all_p), 5)
})

test_that("makeSibling renames duplicate IDs with _2 suffix", {
  skip_if_not(xml_available, skip_msg)
  doc1 <- xmlParse('<html><body><p id="ch1">First</p></body></html>')
  doc2 <- xmlParse('<html><body><p id="ch1">Primero</p></body></html>')
  nodes1 <- xpathSApply(doc1, "//p")
  nodes2 <- xpathSApply(doc2, "//p")
  makeSibling(nodes1, nodes2)
  merged_nodes <- xpathSApply(doc1, "//body/p")
  expect_equal(xmlGetAttr(merged_nodes[[1]], "id"), "ch1")
  expect_equal(xmlGetAttr(merged_nodes[[2]], "id"), "ch1_2")
})

test_that("makeSibling preserves nodes without id attribute", {
  skip_if_not(xml_available, skip_msg)
  doc1 <- xmlParse('<html><body><p>No ID here</p></body></html>')
  doc2 <- xmlParse('<html><body><p>Sin ID aqui</p></body></html>')
  nodes1 <- xpathSApply(doc1, "//p")
  nodes2 <- xpathSApply(doc2, "//p")
  expect_silent(makeSibling(nodes1, nodes2))
  all_p <- xpathSApply(doc1, "//body/p")
  expect_equal(length(all_p), 2)
})
