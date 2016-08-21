require(gdata)
require(jsonlite)

# Read in the data.
tmp <- tempfile()
download.file(
  "https://www.whitehouse.gov/sites/default/files/omb/budget/fy2017/assets/hist03z2.xls",
  destfile=tmp,
  method="curl"
)
df <- read.xls(
  tmp,
  sheet = 1,
  header = TRUE,
  skip = 2,
  stringsAsFactors=FALSE
)
unlink(tmp)

# Remove the weird "X" from all the column names.
names(df) <- sub("^X", "", names(df))

# Remove unnecessary columns.
df[,"Function.and.Subfunction"] <- list(NULL)
df[,"TQ"] <- list(NULL)
df <- df[,-grep("estimate$", colnames(df))]

df <- t(df)

# Make a new data.frame with just the 2 rows we care about.
education <- as.numeric(sub(",", "", df[,70], fixed = TRUE))
justice <- as.numeric(sub(",", "", df[,102], fixed = TRUE))
df <- data.frame('year' = rownames(df), 'education' = education, 'justice' = justice)

# Output to json
json <- toJSON(df)
write(json, "../data/federal-outlays-educations-vs-justice.json")
