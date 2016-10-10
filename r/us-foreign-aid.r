require(tabulizer)
require(jsonlite)
pdfs <- c(
  "http://www.state.gov/documents/organization/224071.pdf",
  "http://www.state.gov/documents/organization/238223.pdf",
  "http://www.state.gov/documents/organization/252735.pdf",
  "http://www.state.gov/documents/organization/238223.pdf",
  "http://www.state.gov/documents/organization/252735.pdf"
)
years <- c("2013 actual", "2014 actual", "2015 actual", "2016 request", "2017 request")
page_ranges <- list(15:22, 14:20, 14:18, 21:26, 19:24)
exports <- list()

for (pdf in 1:length(pdfs)) {
  my_tables <- extract_tables(pdfs[pdf], pages = page_ranges[[pdf]])
  countries <- c()
  totals <- c()
  for (my_table in my_tables) {
    if (length(my_table) > 1) {
      countries <- c(countries, my_table[,1])
      totals <- c(totals, as.numeric(gsub(",", "", my_table[,2])))
    }
  }
  my_frame <- data.frame('country' = countries, 'total' = totals)
  year <- years[pdf]
  exports[[year]] <- my_frame
}
json_file <- "../data/us-foreign-aid.json"
json <- toJSON(exports)
write(json, json_file)
