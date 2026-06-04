### =========================================================================
### RangedSummarizedExperiment objects
### -------------------------------------------------------------------------
###


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Validity
###

### The names and mcols of a RangedSummarizedExperiment must be set on its
### rowRanges slot, not in its NAMES and elementMetadata slots!
.valid.RangedSummarizedExperiment <- function(x)
{
    if (!is.null(x@NAMES))
        return("'NAMES' slot must be set to NULL at all time")
    if (ncol(x@elementMetadata) != 0L)
        return(wmsg("'elementMetadata' slot must contain a zero-column ",
                    "DataFrame at all time"))
    rowRanges_len <- length(x@rowRanges)
    x_nrow <- length(x)
    if (rowRanges_len != x_nrow) {
        txt <- sprintf(
            "\n  length of 'rowRanges' (%d) must equal nb of rows in 'x' (%d)",
            rowRanges_len, x_nrow)
        return(txt)
    }
    NULL
}

### The 'elementMetadata' slot must contain a zero-column DataFrame at all time
### (this is checked by the validity method). The top-level mcols are stored on
### the rowRanges component.
RangedSummarizedExperiment_constructor <- function(rowRanges=GenomicRanges::GRanges(),
                                                   colData=S4Vectors::DataFrame(),
                                                   assays=SimpleList(),
                                                   metadata=list(),
                                                   .s4=TRUE)
{
    if (FALSE)
        new_object()
    assays <- Assays(assays, as.null.if.no.assay=FALSE)
    elementMetadata <- S4Vectors:::make_zero_col_DataFrame(length(rowRanges))
    parent <- SummarizedExperiment(assays=assays,
                                   rowData=elementMetadata,
                                   colData=colData,
                                   metadata=metadata,
                                   checkDimnames=FALSE,
                                   .s4=FALSE)
    object <- new_object(parent, rowRanges=rowRanges)
    if (.s4)
        new_RangedSummarizedExperiment(object)
    else
        object
}

RangedSummarizedExperiment <- new_class("RangedSummarizedExperiment",
    parent=SummarizedExperiment,
    properties=list(
        rowRanges=new_property(
            GenomicRanges_OR_GRangesList_class,
            default=quote(GenomicRanges::GRanges())
        )
    ),
    constructor=RangedSummarizedExperiment_constructor,
    validator=function(self) .valid.RangedSummarizedExperiment(self)
)

RangedSummarizedExperiment_S4Slots <- setShim(RangedSummarizedExperiment)

### Combine the new "parallel slots" with those of the parent class. Make
### sure to put the new parallel slots **first**. See R/Vector-class.R file
### in the S4Vectors package for what slots should or should not be considered
### "parallel".
method(parallel_slot_names, RangedSummarizedExperiment) <-
    function(x) {
        c("rowRanges", callNextMethod())
    }


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Constructor
###

new_RangedSummarizedExperiment <- function(object)
{
    methods::new("RangedSummarizedExperiment",
                 methods::new(RangedSummarizedExperiment_S4Slots, object))
}


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Coercion
###
### See makeSummarizedExperimentFromExpressionSet.R for coercion back and
### forth between SummarizedExperiment and ExpressionSet.
###

.from_RangedSummarizedExperiment_to_SummarizedExperiment <- function(from)
{
    SummarizedExperiment(assays=from@assays,
                         rowData=mcols(from@rowRanges, use.names=FALSE),
                         colData=from@colData,
                         metadata=from@metadata,
                         checkDimnames=FALSE)
}

method(convert, list(RangedSummarizedExperiment, SummarizedExperiment)) <- function(from, to) {
    .from_RangedSummarizedExperiment_to_SummarizedExperiment(from)
}

.from_SummarizedExperiment_to_RangedSummarizedExperiment <- function(from)
{
    partitioning <- PartitioningByEnd(integer(length(from)), names=names(from))
    rowRanges <- relist(GRanges(), partitioning)
    mcols(rowRanges) <- mcols(from, use.names=FALSE)
    RangedSummarizedExperiment(assays=from@assays,
                               rowRanges=rowRanges,
                               colData=from@colData,
                               metadata=from@metadata)
}

method(convert, list(SummarizedExperiment, RangedSummarizedExperiment)) <- function(from, to) {
    .from_SummarizedExperiment_to_RangedSummarizedExperiment(from)
}



### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Accessors
###

### The rowRanges() generic is defined in the MatrixGenerics package.
method(rowRanges, SummarizedExperiment) <- 
    function(x, ...) NULL

### Fix old GRanges instances on-the-fly.
method(rowRanges, RangedSummarizedExperiment) <- 
    function(x, ...) updateObject(x@rowRanges, check=FALSE)

`rowRanges<-` <- new_generic("rowRanges<-", "x",
    function(x, ..., value) S7_dispatch())

.SummarizedExperiment.rowRanges.replace <-
    function(x, ..., value)
{
    if (inherits(x, RangedSummarizedExperiment)) {
        if (is.null(value)) {
            return(convert(x, SummarizedExperiment))
        }
        x <- updateObject(x, check=FALSE)
    } else {
        if (is.null(value)) {
            return(x)
        }
        x <- convert(x, RangedSummarizedExperiment)
    }
    x <- set_props(x, ...,
             rowRanges=value,
             elementMetadata=S4Vectors:::make_zero_col_DataFrame(length(value)),
             .check=FALSE)
    msg <- .valid.SummarizedExperiment.assays_nrow(x)
    if (!is.null(msg))
        stop(msg)
    x
}

method(`rowRanges<-`, SummarizedExperiment) <-
    .SummarizedExperiment.rowRanges.replace

method(names, RangedSummarizedExperiment) <-
    function(x) names(rowRanges(x))

method(`names<-`, RangedSummarizedExperiment) <-
    function(x, value)
{
    rowRanges <- rowRanges(x)
    names(rowRanges) <- value
    set_props(x, rowRanges=rowRanges, .check=FALSE)
}

method(`dimnames<-`, RangedSummarizedExperiment) <-
    function(x, value)
{
    stopifnot(is.list(value))
    rowRanges <- rowRanges(x)
    names(rowRanges) <- value[[1]]
    colData <- colData(x)
    rownames(colData) <- value[[2]]
    set_props(x,
        rowRanges=rowRanges,
        colData=colData,
        .check=FALSE)
}


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Subsetting
###

.DollarNames.RangedSummarizedExperiment <- .DollarNames.SummarizedExperiment

method(subset, RangedSummarizedExperiment) <- 
    function(x, subset, select, ...)
{
    i <- S4Vectors:::evalqForSubset(subset, rowRanges(x), ...)
    j <- S4Vectors:::evalqForSubset(select, colData(x), ...)
    x[i, j]
}


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## colData-as-GRanges compatibility: allow direct access to GRanges /
## GRangesList colData for select functions

## Not supported:
## 
## Not consistent SummarizedExperiment structure: length, names,
##   as.data.frame, c.
## Length-changing endomorphisms: disjoin, gaps, reduce, unique.
## 'legacy' data types / functions: as "RangedData", as "IntegerRangesList",
##   renameSeqlevels, keepSeqlevels.
## Possile to implement, but not yet: Ops, map, window, window<-

## mcols
method(mcols, RangedSummarizedExperiment) <- 
    function(x, use.names=TRUE, ...)
{
    mcols(rowRanges(x), use.names=use.names, ...)
}

method(`mcols<-`, list(RangedSummarizedExperiment, class_any)) <- 
    function(x, ..., value)
{
    set_props(x,
        rowRanges=local({
            r <- rowRanges(x)
            mcols(r) <- value
            r
        }),
        .check=FALSE)
}

### mcols() is the recommended way for accessing the metadata columns.
### Use of values() or elementMetadata() is discouraged.

method(elementMetadata, RangedSummarizedExperiment) <- 
    function(x, use.names=FALSE, ...)
{
    elementMetadata(rowRanges(x), use.names=use.names, ...)
}

method(`elementMetadata<-`, list(RangedSummarizedExperiment, class_any)) <- 
    function(x, ..., value)
{
    elementMetadata(rowRanges(x), ...) <- value
    x
}

## Single dispatch, generic signature fun(x, ...)
local({
    .funs <-
        c("duplicated", "end", "end<-", "ranges", "seqinfo", "seqnames",
          "start", "start<-", "strand", "width", "width<-")

    endomorphisms <- .funs[grepl("<-$", .funs)]

    tmpl <- function() {}
    environment(tmpl) <- parent.frame(2)
    for (.fun in .funs) {
        generic <- getGeneric(.fun)
        formals(tmpl) <- formals(generic)
        fmls <- as.list(formals(tmpl))
        fmls[] <- sapply(names(fmls), as.symbol)
        fmls[[generic@signature]] <- quote(rowRanges(x))
        if (.fun %in% endomorphisms)
            body(tmpl) <- substitute({
                rowRanges(x) <- do.call(FUN, ARGS)
                x
            }, list(FUN=.fun, ARGS=fmls))
        else
            body(tmpl) <-
                substitute(do.call(FUN, ARGS),
                           list(FUN=as.symbol(.fun), ARGS=fmls))
        eval(bquote(method(.(as.symbol(.fun)), RangedSummarizedExperiment) <- tmpl))
    }
})

method(granges, RangedSummarizedExperiment) <- 
    function(x, use.mcols=FALSE, ...)
{
    if (!identical(use.mcols, FALSE))
        stop("\"granges\" method for RangedSummarizedExperiment objects ",
             "does not support the 'use.mcols' argument")
    rowRanges(x)
}

## 2-argument dispatch:
## pcompare / Compare 
## 
.RangedSummarizedExperiment.pcompare <-
    function(x, y)
{
    if (inherits(x, RangedSummarizedExperiment))
        x <- rowRanges(x)
    if (inherits(y, RangedSummarizedExperiment))
        y <- rowRanges(y)
    pcompare(x, y)
}

.RangedSummarizedExperiment.Compare <-
    function(e1, e2)
{
    if (inherits(e1, RangedSummarizedExperiment))
        e1 <- rowRanges(e1)
    if (inherits(e2, RangedSummarizedExperiment))
        e2 <- rowRanges(e2)
    callGeneric(e1=e1, e2=e2)
}

local({
    .signatures <- list(
        list(RangedSummarizedExperiment, class_any),
        list(class_any, RangedSummarizedExperiment),
        list(RangedSummarizedExperiment, RangedSummarizedExperiment))

    for (.sig in .signatures) {
        method(pcompare, .sig) <- .RangedSummarizedExperiment.pcompare
        method(Compare, .sig) <- .RangedSummarizedExperiment.Compare
    }
})

## additional getters / setters

method(`strand<-`, list(RangedSummarizedExperiment, class_any)) <- 
    function(x, ..., value)
{
    strand(rowRanges(x)) <- value
    x
}

method(`ranges<-`, list(RangedSummarizedExperiment, class_any)) <- 
    function(x, ..., value)
{
    ranges(rowRanges(x)) <- value
    x
}

## order, rank, sort

method(is.unsorted, RangedSummarizedExperiment) <- 
    function(x, na.rm = FALSE, strictly = FALSE, ignore.strand = FALSE)
{
    x <- rowRanges(x)
    if (!is(x, "GenomicRanges"))
        stop("is.unsorted() is not yet supported when 'rowRanges(x)' is a ",
             class(x), " object")
    callGeneric()
}

method(order, RangedSummarizedExperiment) <- 
    function(..., na.last=TRUE, decreasing=FALSE,
             method=c("auto", "shell", "radix"))
{
    args <- lapply(list(...), rowRanges)
    do.call("order", c(args, list(na.last=na.last,
                                  decreasing=decreasing,
                                  method=method)))
}

method(rank, RangedSummarizedExperiment) <- 
    function(x, na.last = TRUE,
        ties.method = c("average", "first", "last", "random", "max", "min"))
{
    ties.method <- match.arg(ties.method)
    rank(rowRanges(x), na.last=na.last, ties.method=ties.method)
}

method(sort, RangedSummarizedExperiment) <- 
    function(x, decreasing = FALSE, ignore.strand = FALSE)
{
    x_rowRanges <- rowRanges(x)
    if (!is(x_rowRanges, "GenomicRanges"))
        stop("sort() is not yet supported when 'rowRanges(x)' is a ",
             class(x_rowRanges), " object")
    oo <- GenomicRanges:::order_GenomicRanges(x_rowRanges,
                                              decreasing = decreasing,
                                              ignore.strand = ignore.strand)
    x[oo]
}

## seqinfo (also seqlevels, genome, seqlevels<-, genome<-), seqinfo<-

method(seqinfo, RangedSummarizedExperiment) <- 
    function(x)
{
    seqinfo(x@rowRanges)
}

.set_RangedSummarizedExperiment_seqinfo <-
    function(x, new2old=NULL,
             pruning.mode=c("error", "coarse", "fine", "tidy"),
             value)
{
    if (!is(value, "Seqinfo"))
        stop("the supplied 'seqinfo' must be a Seqinfo object")
    pruning.mode <- match.arg(pruning.mode)
    if (pruning.mode == "fine") {
        if (is(x@rowRanges, "GenomicRanges"))
            stop(wmsg("\"fine\" pruning mode is not supported on ",
                      class(x), " objects with a rowRanges component that ",
                      "is a GRanges object or a GenomicRanges derivative"))
    } else {
        dangling_seqlevels <- Seqinfo:::getDanglingSeqlevels(x@rowRanges,
                                                   new2old=new2old,
                                                   pruning.mode=pruning.mode,
                                                   seqlevels(value))
        if (length(dangling_seqlevels) != 0L) {
            idx <- !(seqnames(x@rowRanges) %in% dangling_seqlevels)
            ## 'idx' should be either a logical vector or a list-like
            ## object where all the list elements are logical vectors (e.g.
            ## a LogicalList or RleList object). If the latter, we transform
            ## it into a logical vector.
            if (is(idx, "List")) {
                if (pruning.mode == "coarse") {
                    idx <- all(idx)  # "coarse" pruning
                } else {
                    idx <- any(idx) | elementNROWS(idx) == 0L  # "tidy" pruning
                }
            }
            ## 'idx' now guaranteed to be a logical vector.
            x <- x[idx]
        }
    }
    seqinfo(x@rowRanges, new2old=new2old, pruning.mode=pruning.mode) <- value
    if (is.character(msg <- .valid.RangedSummarizedExperiment(x)))
        stop(msg)
    x
}
method(`seqinfo<-`, RangedSummarizedExperiment) <- 
    .set_RangedSummarizedExperiment_seqinfo

method(split, list(RangedSummarizedExperiment, class_any, class_any)) <- 
    function(x, f, drop=FALSE, ...)
{
    splitAsList(x, f, drop=drop)
}


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### updateObject()
###

.updateObject_RangedSummarizedExperiment <- function(object, ..., verbose=FALSE)
{
    object <- callNextMethod()
    object@rowRanges <- updateObject(object@rowRanges, ..., verbose=verbose)
    object
}

method(updateObject, RangedSummarizedExperiment) <- 
    .updateObject_RangedSummarizedExperiment
