# Include required libraries.
require(tabulizer)
require(jsonlite)
require(countrycode)

# The pdf files we will be consuming.
pdfs <- c(
  "http://www.state.gov/documents/organization/224071.pdf",
  "http://www.state.gov/documents/organization/238223.pdf",
  "http://www.state.gov/documents/organization/252735.pdf",
  "http://www.state.gov/documents/organization/238223.pdf",
  "http://www.state.gov/documents/organization/252735.pdf"
)
# Some vectors for variations between the pdfs.
page_ranges <- list(15:21, 14:19, 14:18, 20:25, 19:24)
foo <- locate_areas(pdfs[5], pages = page_ranges[[5]])
print(foo)
