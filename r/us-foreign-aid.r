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
years <- c("2013 actual", "2014 actual", "2015 actual", "2016 request", "2017 request")
page_ranges <- list(15:22, 14:20, 14:18, 21:26, 19:24)

# Start an empty list for the full data object which will be converted to json.
exports <- list()

for (pdf in 1:length(pdfs)) {
  # Extract the table from the PDF and construct 2 vectors for country and total.
  my_tables <- extract_tables(pdfs[pdf], pages = page_ranges[[pdf]])
  countries <- c()
  totals <- c()
  for (my_table in my_tables) {
    if (length(my_table) > 1) {
      countries <- c(countries, my_table[,1])
      totals <- c(totals, as.numeric(gsub(",", "", my_table[,2])))
    }
  }
  # Create a data frame from the 2 vectors.
  my_frame <- data.frame('country' = countries, 'total' = totals)
  # Remove rows without data.
  my_frame <- my_frame[!(is.na(my_frame$country) | my_frame$country == ""),]
  my_frame <- my_frame[!(is.na(my_frame$total) | my_frame$total == ""),]
  # Add country codes for consistent rendering later.
  my_frame$code <- countrycode(my_frame$country, "country.name", "iso3c")
  # Remove rows that did not get a country code.
  # TODO: This removes Kosovo, can we avoid that?
  my_frame <- my_frame[!is.na(my_frame$code),]
  # Add to the main list for later exporting to json.
  year <- years[pdf]
  exports[[year]] <- my_frame
}
# Write the main json file.
json_file <- "../data/us-foreign-aid.json"
json <- toJSON(exports)
write(json, json_file)
