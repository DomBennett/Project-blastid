chck <- function(nm, sbfl) {
  fls <- list.files(file.path('cache', sbfl))
  nms <- sub('\\.RData', '', fls)
  nm %in% nms
}

svObj <- function(nm, obj, sbfl) {
  fl <- file.path('cache', sbfl, paste0(nm, '.RData'))
  saveRDS(object=obj, file=fl)
}

ldObj <- function(nm, sbfl) {
  fl <- file.path('cache', sbfl, paste0(nm, '.RData'))
  readRDS(fl)
}
