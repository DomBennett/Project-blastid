chck <- function(nm) {
  fls <- list.files('cache')
  nms <- sub('\\.RData', '', fls)
  nm %in% nms
}

svObj <- function(nm, obj) {
  fl <- file.path('cache', paste0(nm, '.RData'))
  saveRDS(object=obj, file=fl)
}

ldObj <- function(nm) {
  fl <- file.path('cache', paste0(nm, '.RData'))
  readRDS(fl)
}
