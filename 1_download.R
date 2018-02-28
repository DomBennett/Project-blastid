# DOWNLOAD SEQUENCES IN BATCHES

# LIBS
library(rentrez)
source(file.path('tools', 'cache_tools.R'))

# VARS
srch_trm <- '140[SLEN]:3000[SLEN])) AND (((ITS1[titl] OR ITS2[titl]) OR 5.8S[titl]) OR "internal transcribed spacer"[titl] OR "internal transcribed spacers"[titl] OR "ITS 1" [titl] OR "ITS 2"[titl])'
otfl <- 'its_downloaded_sequences.fasta'

# IDENTIFY
cat('Searching IDs ...\n')
if(chck('srch_rs')) {
  srch_rs <- ldObj('srch_rs')
} else {
  srch_rs <- entrez_search(db='nucleotide',
                           term=srch_trm, retmax=1633026)
  svObj(obj=srch_rs, nm='srch_rs')
}
cat('Done.\n')

# DOWNLOAD IN BATCHES
cat('Downloading ...\n')
gis <- srch_rs[['ids']]
gis <- sort(gis)
btch_is <- c(seq(0, length(gis), 500), length(gis))
sqs <- vector(length=length(gis))
names(sqs) <- gis
for(i in 2:length(btch_is)) {
  cat(' ... [', i-1, '/', length(btch_is)-1, ']\n', sep='')
  btch <- (btch_is[(i-1)]+1):btch_is[i]
  crrnt <- gis[btch]
  if(chck(i, sbfl='1_download')) {
    tmp <- ldObj(i, sbfl='1_download')
  } else {
    crrnt_rs <- entrez_fetch(db='nucleotide', id=crrnt,
                             rettype='fasta')
    tmp <- unlist(strsplit(crrnt_rs, "(?<=[^>])(?=\n>)", perl=TRUE))
    names(tmp) <- crrnt
    svObj(obj=tmp, nm=i, sbfl='1_download')
  }
  sqs[crrnt] <- tmp
}
cat('Done.\n')

# SAVE
cat('Saving ...\n')
otfl <- file.path('data', otfl)
if(file.exists(otfl)) {
  file.remove(otfl)
}
pull <- sqs != 'FALSE'
for(sq in sqs[pull]) {
  cat(sq, file=otfl, append=TRUE)
}
cat('Done.\n')