
grabFolder <- function(folder){
   files <- list.files(folder)
   purrr::walk(files, function(f){
      assign(f, read.csv(paste0(folder,'/',f), stringsAsFactors = FALSE), envir = .GlobalEnv)
   })
}

saveList <- function(dataframes,dest){
   if(is.null(names(dataframes))) stop("List must have names")
   i <- 1
   lapply(dataframes, function(df){
      dest <- paste0(dest,'/',names(dataframes)[i],'.csv')
      write.csv(df,dest,row.names = FALSE)
      i <<- i + 1
   })
}

pushData <- function(con,dataframes, ...){
   if(is.null(names(dataframes))) stop("List must have names")
   i <- 1
   for(df in dataframes){
      dbWriteTable(con,names(dataframes)[i],df, ...)
      i <- i + 1
   }
}
