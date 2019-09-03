
# ====================================================================

#' relationize
#'
#' Turn a data frame into two dataframes, connected by a common
#' identifier. Semantically, this function should be used to  
#' separate units of analysis into separate tables.
#'
#' Especially useful when working with relational databases.
#'
#' @param data A \code{data.frame}
#' @param key.x The variable in \code{data} that corresponds with the primary key in y 
#' @param key.y The variable in y that acts as a primary key.
#' @param keep Keep this variable in X, even if its relegated to y. 
#' @param ... variables to send to Y
#' @return A list of two data frames
#' @export

relationize <- function(data,...,key.x = y, key.y = uid, keep = NULL){
   variables <- alist(...)
   variables_char <- sapply(eval(substitute(alist(...))), deparse)

   args <- c(list(data),variables)

   key.x <- deparse(substitute(key.x))
   key.y <- deparse(substitute(key.y))

   x <- data
   y <- unique(do.call(dplyr::select,args))

   # Existing key
   if(key.y %in% names(y)){
      x[[key.x]] <- x[[key.y]]

   # New key 
   } else {
      y[[key.y]] <- 1:nrow(y) 
      x <- merge(x,y, 
                 by.x = variables_char, by.y = variables_char, 
                 all.x = TRUE, all.y = FALSE) %>% 
         unique()
      x[[key.x]] <- x[[key.y]]
      x[[key.y]] <- NULL
   }

   # ================================================
   # Tests

   if(nrow(y) > length(unique(y[[key.y]]))){
      uvals = sapply(y,function(var) length(unique(var)))
      names(uvals) <- names(y)
      warning(paste0(glue::glue("Primary key {key.y} has fewer unique values than ",
                     "there are rows in the resulting data ({nrow(y)}). "),
                     "This is because there is within-obs variation ",
                     "on one of the variables:\n",
                     glue::glue_collapse(paste(names(uvals),uvals, sep = ': '), 
                                   sep = '\n')))
   }

   remove <- variables_char[variables_char != key.x]
   if(!is.null(keep)){
      remove <- remove[!remove %in% as.character(keep)]
   }
   x <- x[!names(x) %in% remove]
   list(x,y)
}

# ====================================================================

#' duplicatedUnits 
#'
#' Returns rows with duplicated values for an assumed primary key.
#'
#' @param data A \code{data.frame}
#' @param key The assumed primary key 
#' @return A \code{data.frame} containing duplicates
#' @export

duplicatedUnits <- function(data, key){
   key <- deparse(substitute(key))
   dups <- unlist(data[duplicated(data[[key]]),key])
   data[data[[key]] %in% dups,]
}

# ====================================================================

#' doRelationize 
#'
#' Turn a single data.frame into several related data.frames. 
#' This function takes keyword-named alists, containing arguments for each
#' relationalize-call. Each of the alists will be called, and the result is returned
#' as a named list containing the related data.frames, with "head" being the
#' "primary" table that is used to create the relations.
#'
#' @param data A \code{data.frame}
#' @param ... named alists containing arguments for relationalize 
#' @return A list of several related data.frames 
#' @export

doRelationize <- function(data, ...){
   args <- eval(substitute(alist(...)))
   relationnames <- names(args)
   if(is.null(relationnames) | any(relationnames == '')){
      stop("Relations (arguments) must be named")
   }

   result <- list()
   data <- data
   for(i in 1:length(args)){
      args_ <- c(list(data),eval(args[[i]]))
      data_and_relation <- do.call("relationize",args_)
      result[[i+1]] <- data_and_relation[[2]]
      data <- data_and_relation[[1]]
   }
   result[[1]] <- data
   names(result) <- c('head',relationnames) 
   result
}
