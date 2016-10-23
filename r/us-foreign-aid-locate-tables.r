# This is a scratch R script for outputing the "areas" of a table in a PDF.
# For an example of how the output is used, see us-foreign-aid.r.

# Include required libraries.
require(tabulizer)

# Change this pdf to whatever you want to analyze.
pdf <- "http://www.state.gov/documents/organization/224071.pdf";
# Change the page range to the part of the PDF you care about.
page_range <- 15:21

# No need to change the below code.
output <- locate_areas(pdf, pages = page_range)
print(output)

#TODO: Can this be output in a more R-script friendly way?
