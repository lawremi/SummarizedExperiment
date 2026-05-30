### =========================================================================
### nearest (and related) methods
### -------------------------------------------------------------------------
###


### precede & follow

method(precede, list(RangedSummarizedExperiment, class_any)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    precede(rowRanges(x), subject, select=select, ignore.strand=ignore.strand)
}

method(precede, list(class_any, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    precede(x, rowRanges(subject), select=select, ignore.strand=ignore.strand)
}

method(precede, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    precede(rowRanges(x), rowRanges(subject), select=select, ignore.strand=ignore.strand)
}

method(follow, list(RangedSummarizedExperiment, class_any)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    follow(rowRanges(x), subject, select=select, ignore.strand=ignore.strand)
}

method(follow, list(class_any, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    follow(x, rowRanges(subject), select=select, ignore.strand=ignore.strand)
}

method(follow, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    follow(rowRanges(x), rowRanges(subject), select=select, ignore.strand=ignore.strand)
}


### nearest

method(nearest, list(RangedSummarizedExperiment, class_any)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    nearest(rowRanges(x), subject, select=select, ignore.strand=ignore.strand)
}

method(nearest, list(class_any, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    nearest(x, rowRanges(subject), select=select, ignore.strand=ignore.strand)
}

method(nearest, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(x, subject, select=c("arbitrary", "all"), ignore.strand=FALSE)
{
    nearest(rowRanges(x), rowRanges(subject), select=select, ignore.strand=ignore.strand)
}


### distance

method(distance, list(RangedSummarizedExperiment, class_any)) <-
    function(x, y, ignore.strand=FALSE, ...)
{
    distance(rowRanges(x), y, ignore.strand=ignore.strand, ...)
}

method(distance, list(class_any, RangedSummarizedExperiment)) <-
    function(x, y, ignore.strand=FALSE, ...)
{
    distance(x, rowRanges(y), ignore.strand=ignore.strand, ...)
}

method(distance, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(x, y, ignore.strand=FALSE, ...)
{
    distance(rowRanges(x), rowRanges(y), ignore.strand=ignore.strand, ...)
}


### distanceToNearest

method(distanceToNearest, list(RangedSummarizedExperiment, class_any)) <-
    function(x, subject, ignore.strand=FALSE, ...)
{
    distanceToNearest(rowRanges(x), subject, ignore.strand=ignore.strand, ...)
}

method(distanceToNearest, list(class_any, RangedSummarizedExperiment)) <-
    function(x, subject, ignore.strand=FALSE, ...)
{
    distanceToNearest(x, rowRanges(subject), ignore.strand=ignore.strand, ...)
}

method(distanceToNearest, list(RangedSummarizedExperiment, RangedSummarizedExperiment)) <-
    function(x, subject, ignore.strand=FALSE, ...)
{
    distanceToNearest(rowRanges(x), rowRanges(subject), ignore.strand=ignore.strand, ...)
}
