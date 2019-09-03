source('relationalize.R')
source('regularize.R')

cfs <- read.csv('data/cf_4_4.csv', stringsAsFactors = FALSE)
cfs <- regularize(cfs)

cfs$actor_name <- gsub('\\s+',' ',cfs$actor_name)


cfs$locid <- paste0(cfs$CC,'-',cfs$CF_ID)
cfs$acid <- paste0(cfs$CC,'-',cfs$actor_name)


relation_defs <- list(actors = alist(UCDP_Actor_ID, actor_name, acid,
                                        key.x = acid, key.y = acid),

                      locations = alist(CC, Location, Region, 
                                        key.x = CC, key.y = CC),

                      ceasefires = alist(CF_effect_yr, CF_effect_month, CF_ID,
                                         CF_effect_day, written, Purpose_1,
                                         Purpose_2, Mediator_nego, Mediator_send,
                                         Implement, Enforcement, locid,
                                         key.x = locid, key.y = locid))

args <- c(list(cfs), relation_defs)
relations <- do.call(doRelationize,args) 
