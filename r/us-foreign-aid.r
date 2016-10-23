# Include required libraries.
require(tabulizer)
require(jsonlite)
require(countrycode)

# The pdf files we will be consuming.
pdfs <- c(
  "http://www.state.gov/documents/organization/224071.pdf",
  "http://www.state.gov/documents/organization/238223.pdf",
  "http://www.state.gov/documents/organization/252735.pdf"
)
# Some vectors for variations between the pdfs.
years <- c("2013", "2014", "2015")
page_ranges <- list(15:21, 14:19, 14:18)
areas <- list(
    list(
        c(93.59996,47.59993,574.39977,240.39985),
        c(93.59996,46.79993,580.79977,238.79985),
        c(94.39996,47.59993,583.19977,241.19985),
        c(95.19996,47.59993,581.59977,239.59985),
        c(95.19996,49.19992,575.19977,242.79985),
        c(94.39996,47.59993,581.59977,242.79985),
        c(95.19996,48.39993,158.39994,237.99985)
    ),
    list(
        c(97.59996,31.59993,582.39977,225.19985),
        c(97.59996,32.39993,577.59977,225.19985),
        c(95.99996,31.59993,573.59977,225.19985),
        c(96.79996,31.59993,581.59977,228.39985),
        c(96.79996,31.59993,579.99977,225.99985),
        c(97.59996,31.59993,501.59980,224.39985)
    ),
    list(
        c(77.59997,30.79993,580.79977,242.79985),
        c(79.19997,31.59993,575.19977,242.79985),
        c(77.59997,30.79993,575.19977,241.99985),
        c(78.39997,33.19993,582.39977,241.19985),
        c(78.39997,30.79993,531.19979,241.99985)
    )
)

# Start an empty list for the full data object which will be converted to json.
exports <- list()

for (pdf in 1:length(pdfs)) {
  # Extract the table from the PDF and construct 2 vectors for country and total.
  my_tables <- extract_tables(pdfs[pdf], pages = page_ranges[[pdf]], guess = FALSE, area = areas[[pdf]])
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
