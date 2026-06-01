### Since client code likely relies on coercions via as(), define them here

methods::setAs("Assays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SimpleAssays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SimpleList", "SimpleAssays", function(from) {
    convert(from, SimpleAssays)
})

methods::setAs("SummarizedExperiment::AssaysInEnv", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SimpleList", "SummarizedExperiment::AssaysInEnv", function(from) {
    convert(from, AssaysInEnv)
})

methods::setAs("RangedSummarizedExperiment", "SummarizedExperiment", function(from) {
    convert(from, SummarizedExperiment_class)
})  

methods::setAs("SummarizedExperiment", "RangedSummarizedExperiment", function(from) {
    convert(from, RangedSummarizedExperiment)
})

methods::setAs("ExpressionSet", "RangedSummarizedExperiment", function(from) {
    convert(from, RangedSummarizedExperiment)
})

methods::setAs("ExpressionSet", "SummarizedExperiment", function(from) {
    convert(from, SummarizedExperiment_class)
})

methods::setAs("RangedSummarizedExperiment", "ExpressionSet", function(from) {
    convert(from, ExpressionSet_class)
})

methods::setAs("SummarizedExperiment", "ExpressionSet", function(from) {
    convert(from, ExpressionSet_class)
})
