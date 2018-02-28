# BLAST ENVIRONMENTAL AGAINST DOWNLOADED

# LIBS
library(sys)

# VARS
strand <- 'both'
ncpus <- 2
query <- 'ITS_otus.fa'
subject <- 'its_downloaded_sequences.fasta'
dbfl <- 'its_downloaded_sequences.dbfl'
otfl <- 'its_blast_res'
blstnpth <- '/home/dom/Programs/ncbi-blast-2.7.1+/bin/blastn'
mkblstdbpth <- '/home/dom/Programs/ncbi-blast-2.7.1+/bin/makeblastdb'

# MAKE BLAST DB
subject <- file.path('data', subject)
dbfl <- file.path('data', dbfl)
args <- c('-in', subject, '-out', dbfl,
          '-dbtype', 'nucl')
exec_wait(cmd=mkblstdbpth, args=args)

# BLAST
otfl <- file.path('data', otfl)
query <- file.path('data', query)
args <- c('-strand', strand, '-num_threads',
          ncpus, '-query', query, '-db', dbfl,
          '-out', otfl, '-task', 'blastn',
          '-outfmt', '6', '-max_target_seqs', '1',
          '-evalue', '0.001', '-word_size', '7',
          '-reward', '1', '-penalty', '-1',
          '-gapopen', '1', '-gapextend', '2')
exec_wait(cmd=blstnpth, args=args)
