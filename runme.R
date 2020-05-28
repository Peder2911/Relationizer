#!/usr/bin/Rscript

source('relationalize.R')
source('regularize.R')
source('helper.R')

tgt <- commandArgs(trailingOnly = TRUE)[1]

cfs <- read.csv(tgt, stringsAsFactors = FALSE)
cfs <- regularize(cfs)

cfs$actor_name <- gsub('\\s+',' ',cfs$actor_name)


cfs$locid <- paste0(cfs$cc,'-',cfs$cf_id)
cfs$acid <- paste0(cfs$cc,'-',cfs$actor_name)


relation_defs <- list(actors = alist(ucdp_actor_id, actor_name, acid,
                                        key.x = acid, key.y = acid),

                      locations = alist(cc, location, region, 
                                        key.x = cc, key.y = cc),

                      ceasefires = alist(cf_effect_yr, cf_effect_month, cf_id,
                                         cf_effect_day, written, purpose_1,
                                         purpose_2, mediator_nego, mediator_send,
                                         implement, enforcement, locid,
                                         ceasefire_class,
                                         key.x = locid, key.y = locid))

args <- c(list(cfs), relation_defs)
relations <- do.call(doRelationize,args) 

saveList(relations,'relations')
