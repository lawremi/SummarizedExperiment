### =========================================================================
### Inter-range methods
### -------------------------------------------------------------------------
###


method(isDisjoint, RangedSummarizedExperiment) <-
    function(x, ignore.strand=FALSE)
    {
        isDisjoint(rowRanges(x), ignore.strand=ignore.strand)
    }

method(disjointBins, RangedSummarizedExperiment) <-
    function(x, ignore.strand=FALSE)
    {
        disjointBins(rowRanges(x), ignore.strand=ignore.strand)
    }
