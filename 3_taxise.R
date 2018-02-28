# LOOK UP TAXONOMY

# LIBS
library(rentrez)
source(file.path('tools', 'cache_tools.R'))

# VARS
otfl <- 'its_results.csv'
infl <- 'its_blast_res'
headers <- c('qseqid', 'sseqid', 'pident',
             'length', 'mismatch', 'gapopen',
             'qstart', 'qend', 'sstart', 'send',
             'evalue', 'bitscore')

# INPUT
infl <- file.path('data', infl)
blst_rs <- read.table(file=infl, sep='\t',
                      stringsAsFactors=FALSE)
colnames(blst_rs) <- headers

# GET TXIDS
cat('Searching txids ...\n')
all_sids <- blst_rs[['sseqid']]
all_sids <- sort(unique(all_sids))
btch_is <- c(seq(0, length(all_sids), 500), length(all_sids))
txids <- vector(length=length(all_sids))
names(txids) <- all_sids
for(i in 2:length(btch_is)) {
  cat(' ... [', i-1, '/', length(btch_is)-1, ']\n', sep='')
  btch <- (btch_is[(i-1)]+1):btch_is[i]
  crrnt <- all_sids[btch]
  if(chck(i, sbfl='3_taxise_txids')) {
    tmp <- ldObj(i, sbfl='3_taxise_txids')
  } else {
    smmry_rs <- entrez_summary(db='nucleotide', id=crrnt)
    tmp <- vapply(smmry_rs, function(x) x[['taxid']], 1)
    tmp <- as.character(tmp)
    names(tmp) <- crrnt
    svObj(obj=tmp, nm=i, sbfl='3_taxise_txids')
  }
  txids[crrnt] <- tmp
}
cat('Done.\n')

# GET LINEAGES
cat('Searching lineages ...\n')
all_txids <- txids
txids <- sort(unique(txids))
btch_is <- c(seq(0, length(txids), 500), length(txids))
lngs <- vector('list', length=length(txids))
names(lngs) <- txids
for(i in 2:length(btch_is)) {
  cat(' ... [', i-1, '/', length(btch_is)-1, ']\n', sep='')
  btch <- (btch_is[(i-1)]+1):btch_is[i]
  crrnt <- txids[btch]
  if(chck(i, sbfl='3_taxise_lngs')) {
    rcrds <- ldObj(i, sbfl='3_taxise_lngs')
  } else {
    ftch_rs <- entrez_fetch(db='taxonomy', id=crrnt, rettype='xml')
    rcrds <- XML::xmlToList(ftch_rs)
    svObj(obj=rcrds, nm=i, sbfl='3_taxise_lngs')
  }
  tmp <- vapply(rcrds, function(x) x[['Lineage']], '')
  #tmp <- strsplit(tmp, split='; ')
  names(tmp) <- crrnt
  lngs[crrnt] <- tmp
}
cat('Done.\n')

# WRITE OUT
otfl <- file.path('data', otfl)
newcols <- data.frame('txid'=rep(NA, nrow(blst_rs)),
                      'lng'=rep(NA, nrow(blst_rs)))
for(i in 1:nrow(blst_rs)) {
  sid <- blst_rs[i, 'sseqid']
  txid <- all_txids[sid == names(all_txids)]
  lng <- lngs[txid == names(lngs)]
  newcols[i, 'txid'] <- txid
  newcols[i, 'lng'] <- lng
}
res <- cbind(blst_rs, newcols)
write.csv(x=res, file=otfl)
