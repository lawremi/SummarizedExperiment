### =========================================================================
### Intra-range methods
### -------------------------------------------------------------------------
###


method(shift, RangedSummarizedExperiment) <-
    function(x, shift=0L, use.names=TRUE)
    {
        x0 <- x
        rowRanges(x0) <- shift(rowRanges(x), shift=shift, use.names=use.names)
        x0
    }

method(narrow, RangedSummarizedExperiment) <-
    function(x, start=NA, end=NA, width=NA, use.names=TRUE)
    {
        x0 <- x
        rowRanges(x0) <- narrow(rowRanges(x), start=start, end=end, width=width, use.names=use.names)
        x0
    }

method(resize, RangedSummarizedExperiment) <-
    function(x, width, fix="start", use.names=TRUE, ignore.strand=FALSE)
    {
        x0 <- x
        rowRanges(x0) <- resize(rowRanges(x), width=width, fix=fix, use.names=use.names, ignore.strand=ignore.strand)
        x0
    }

method(flank, RangedSummarizedExperiment) <- 
    function(x, width, start=TRUE, both=FALSE, use.names=TRUE,
             ignore.strand=FALSE)
    {
        x0 <- x
        rowRanges(x0) <- flank(rowRanges(x), width=width, start=start, both=both, use.names=use.names, ignore.strand=ignore.strand)
        x0
    }

method(promoters, RangedSummarizedExperiment) <-
    function(x, upstream=2000, downstream=200)
    {
        x0 <- x
        rowRanges(x0) <- promoters(rowRanges(x), upstream=upstream, downstream=downstream)
        x0
    }

method(terminators, RangedSummarizedExperiment) <-
    function(x, upstream=2000, downstream=200)
    {
        x0 <- x
        rowRanges(x0) <- terminators(rowRanges(x), upstream=upstream, downstream=downstream)
        x0
    }

### Because 'keep.all.ranges' is FALSE by default, it will break if some
### ranges are dropped.
method(restrict, RangedSummarizedExperiment) <-
    function(x, start=NA, end=NA, keep.all.ranges=FALSE, use.names=TRUE)
    {
        x0 <- x
        rowRanges(x0) <- restrict(rowRanges(x), start=start, end=end, keep.all.ranges=keep.all.ranges, use.names=use.names)
        x0
    }

method(trim, RangedSummarizedExperiment) <-
    function(x, use.names=TRUE)
    {
        x0 <- x
        rowRanges(x0) <- trim(rowRanges(x), use.names=use.names)
        x0
    }
