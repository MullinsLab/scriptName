if (file.exists("../../DESCRIPTION")) {
  devtools::load_all("../../", quiet = T)
} else {
  library("scriptName")
}
str(current_filename())
