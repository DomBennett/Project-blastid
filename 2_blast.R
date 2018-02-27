# BLAST ENVIRONMENTAL AGAINST DOWNLOADED

# LIBS
library(sys)

# VARS
strand <- 'both'
ncpus <- 2
query <- 'environmental_sequences.fasta'
subject <- 'downloaded_sequences.fasta'
dbfl <- 'download_sequences.dbfl'
blstnpth <- ''
mkblstdbpth <- ''

# MAKE BLAST DB
args <- c('-in', subject, '-out', dbfl,
          '-dbtype', 'nucl')
exec_wait(cmd=mkblstdbpth, args=args)

# BLAST
args <- c('-strand', strand, '-num_threads',
          ncpus, '-query', query, '-db', dbfl,
          '-out', otfl, '-task', 'blastn',
          '-outfmt', '6', '-max_target_seqs', '1',
          '-evalue', '0.001', '-word_size', '7',
          '-reward', '1', '-penalty', '1',
          '-gapopen', '1', '-gapextend', '2')
exec_wait(cmd=blstnpth, args=args)

# CLEAN UP
