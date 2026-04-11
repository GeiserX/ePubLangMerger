library(testthat)

# Source only the pure-R functions from utils.R, stripping the library(XML)
# call which would fail in CI where XML is not installed.
local({
  utils_path <- file.path(
    Sys.getenv("GITHUB_WORKSPACE", unset = getwd()), "utils.R"
  )
  lines <- readLines(utils_path)
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
