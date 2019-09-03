
library(stringr)

regularizeString <- function(x){
   str_replace_all(x, "\\s+"," ") %>%
      str_trim()
}

regularize <- function(data){
   charcols <- which(sapply(data, class) == "character")
   for(c in charcols){
      data[[c]] <- regularizeString(data[[c]])
   }
   data

}
