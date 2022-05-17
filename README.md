# Quick.CBBI
This respository is used to record the basic information of computational biology and bioinformatics

# FASTQ & FASTQC
1. fastq file:

*formate:

1)sequence ID
2) sequence
3) Quality ID
4) Quality score

*phred quality:

• ASCII of : sequence quality +33
• -10log10 Pr(bp is wrongly sequenced)
FASTQ = sequence "reads" + quality
common tool: FASTQC

# local alignment

1. local alignment

• align regions having highest similarities between 2 sequences
• stretches of sequences with highest density of matches are aligned
• more suitable for partially similar, different length and conserved regions containing sequences
• align substring of target sequence with substrings of query sequence
• suitable for divergent sequences
• most general local alignment algorithm is the Smith Waterman
  global alignment: needleman-wumsch

2. global alignment VS local alignment

global alignment:
tires to align entire sequence align all letters from query and target suitable for closely related sequences

local alignment:
align regions having highest similarities 
align substring of target with substring of query

3. sequence mapping algorithms
 Seed
• mapping hundreds of millions reads back to the reference genome is CPU and RAM intensive and slow
• most mappers allow ~2 mismatches within first 30bp (4**28 could still uniquely identify most 30bp sequences in a 3GB genome), slower when allowing indels
• Seed: break DB sequence into k-mer words(seed) and hash their locations to speed later searches

BLAST algorithm steps
• seed-and-extend paradigm
• for each k-mer in query, find possible DB k-mers that matches well with it
• only words with >=T cutoff sore are kept
• for each DB sequence with a high scoring word, try to extend it in both ends
    form HSP(High-scoring segment pairs)
• keep only statistically significant HSPs
    based on the score of aligning 2 random seqs
• use Smith-Waterman algorithm to join the HSPs and get optimal alignment

SUFFIX Tree
• a tree of all the suffixes of the reference 
 e.g. "BANANA" has suffixes: BANANA, ANANA, NANA, ..., A
• used in alignment tools such as MUMmer
• O(n) time to build.
  n=genome build 
• O(m) time to search
  m=query length
Genome index is big
  ~50GB

SUFFIX Array
• the ith entry corresponds to the ith smallest suffix
• used in alignment tool such as STAR
• O(n) time to build
  n= genome length
• O(mlogn) time to search 
  Binary search
  m = query length 
• index size is moderate
  ~15GB

Borrows-Wheeler transformation & LF mapping
• most widely used tools: bwa, bowtie
• reversible permutation used originally in compression
• database sequence T = acaacg$
$acaacg                $acaacg                  $acaacg
g$acaac                aacg$ac                  aacg$ac
cg$acaa                acaacg$                  acaacg$
acg$aca     ----->     acg$aca   ------>        acg$aca  -----> gc$aaac
aacg$ac                caacg$a                  caacg$a .        BWT(T)
caacg$a                cg$acaa                  cg$acaa
acaacg$                g$acaac                  g$acaac
                        Burrows                last column
                        wheeler
                        matrix
  
• why BWT is useful for compression?
• Once BWT (T) is built, everything else is discarded
• First column of BWM can be derived by sorting BWT(T)
• Characters will tend to cluster together
    BWT(T) = gc$aaac -> compression ->gc$3ac
• how can we recreate T using BWT(T)?
 LF mapping
• how to use BWT(T) to retrieve alignments given a query sequence Q?
• property that makes BWT(T) reversible is "LF mapping"
    i th occurrence of a character in the last column is the same text occurrence as the i th occurrence in the first column 
• to recreate T from BT(T), repeatedly apply rule:
  T = BWT[LF(i)] + T; i = LF(i)
• where LF(i) maps row i to row whose first character corresponds to i's last per LF mapping

• why BWT is useful for compression?
• Once BWT (T) is built, everything else is discarded
• First column of BWM can be derived by sorting BWT(T)
• Characters will tend to cluster together
    BWT(T) = gc$aaac -> compression ->gc$3ac
• how can we recreate T using BWT(T)?
 LF mapping
• how to use BWT(T) to retrieve alignments given a query sequence Q?
• property that makes BWT(T) reversible is "LF mapping"
    i th occurrence of a character in the last column is the same text occurrence as the i th occurrence in the first column 
• to recreate T from BT(T), repeatedly apply rule:
  T = BWT[LF(i)] + T; i = LF(i)
• where LF(i) maps row i to row whose first character corresponds to i's last per LF mapping

4.BW Alignment
BWT(T) to retrieve alignments
• to match Q in T using BWT(T), repeatedly apply rule:
• top = LF(top, qc); bot = LF(bot, qc)
• where qc is the next character in Q (right-to-left) and LF(i, qc) maps row i to the row whose first character corresponds to i's last character as if it were qc
• in progressive rounds, top & bot delimit the range of rows beginning with progressively longer suffixes of Q (from right to left)
• if range becomes empty the query suffix(and therefore the query) does not occur in the text
• if no match, instead of giving up, try to "backtrack" to a previous position and try a different base(mismatch, much slower)
• how to recover the query sequence(Q) alignment position in the reference sequence T? LF mapping
• store index of subset of first and last column to speed up

summary of the Burrows-wheeler
• use Burrows-Wheeler transform to store entire reference genome as a lookup index
• align tag base by base from the end
• all active locations are reported
• if no match is found, then back up and try a substitution.
ben lagmead videos

alignment output: SAM and BED

SAM file header
@HD-header line
@SQ-reference genome information
@RG-read group information
@PG-program(software) information

read name
Map: 0 OK, 4 unmapped, 16 mapped reverse strand
Sequence, quality score, XA(mapper-specific)
MD: mismatch info:3 match, then C ref, 30 match, then T ref, 3 match
NM: number of mismatch
BAM: binary compressed SAM format

BED & BigBED File
• barely used to store full alignments: usually stores other types of genomic intervals
• BigBed:Binary compressed & indexed BED file






