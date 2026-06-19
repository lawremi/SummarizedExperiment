SimpleList_class <- methods::getClass("SimpleList")
ExpressionSet_class <- methods::getClass("ExpressionSet")
DataFrame_class <- methods::getClass("DataFrame")
Vector_class <- methods::getClass("Vector")
GenomicRanges_class <- methods::getClass("GenomicRanges")
IntegerRanges_class <- methods::getClass("IntegerRanges")
Rle_class <- methods::getClass("Rle")
GenomicRanges_OR_GRangesList_class <- methods::getClass("GenomicRanges_OR_GRangesList")
RectangularData_class <- methods::getClass("RectangularData")

## Attempt to keep the exported S4 classes alive by proxy
setS4Class <- function(class, parent = NULL) {
    s4_class <- S4_register(class, contains=TRUE)
    setClass(class@name, contains=c(s4_class, parent))
    s4_class
}

setS4Generic <- function(generic, where = parent.frame()) {
    s7_generic <- generic

    args <- names(formals(generic))
    call_args <- lapply(args, as.name)
    names(call_args) <- args
    names(call_args)[args == "..."] <- ""
    body <- as.call(c(as.name(generic@name), call_args))
    wrapper <- as.function(c(formals(generic), list(body)), where)

    methods::setGeneric(
        generic@name,
        wrapper,
        signature = generic@dispatch_args,
        where = where
    )
    methods::setGenericImplicit(generic@name, where = where, restore = FALSE)
    assign(generic@name, s7_generic, envir = where)
    invisible(generic)
}
