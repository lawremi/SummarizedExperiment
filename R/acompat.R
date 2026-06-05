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
setShim <- function(class, parent = NULL) {
    slots_class <- S4_register_contains(class)
    setClass(class@name, contains = slots_class)
    if (!is.null(parent))
        setIs(class@name, parent)
    slots_class
}
