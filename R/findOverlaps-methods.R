### =========================================================================
### findOverlaps methods
### -------------------------------------------------------------------------


### findOverlaps

method(findOverlaps, list(RangedSummarizedExperiment, Vector_class)) <-
    function(query, subject, maxgap=-1L, minoverlap=0L,
             type=c("any", "start", "end", "within", "equal"),
             select=c("all", "first", "last", "arbitrary"),
             ignore.strand=FALSE)
    {
        findOverlaps(rowRanges(query), subject, maxgap=maxgap, minoverlap=minoverlap,
                     type=type, select=select, ignore.strand=ignore.strand)
    }

method(findOverlaps, list(Vector_class, RangedSummarizedExperiment)) <-
    function(query, subject, maxgap=-1L, minoverlap=0L,
             type=c("any", "start", "end", "within", "equal"),
             select=c("all", "first", "last", "arbitrary"),
             ignore.strand=FALSE)
    {
        findOverlaps(query, rowRanges(subject), maxgap=maxgap, minoverlap=minoverlap,
                     type=type, select=select, ignore.strand=ignore.strand)
    }

method(findOverlaps, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(query, subject, maxgap=-1L, minoverlap=0L,
             type=c("any", "start", "end", "within", "equal"),
             select=c("all", "first", "last", "arbitrary"),
             ignore.strand=FALSE)
    {
        findOverlaps(rowRanges(query), rowRanges(subject), maxgap=maxgap, minoverlap=minoverlap,
                     type=type, select=select, ignore.strand=ignore.strand)
    }
