### =========================================================================
### "coverage" method
### -------------------------------------------------------------------------
###


method(coverage, RangedSummarizedExperiment) <-
    function(x, shift=0L, width=NULL, weight=1L,
                method=c("auto", "sort", "hash"))
    {
        method <- match.arg(method)
        coverage(rowRanges(x), shift=shift, width=width, weight=weight, method=method)
    }
