### Since client code likely relies on coercions via as(), define them here

methods::setAs("SummarizedExperiment::Assays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SummarizedExperiment::SimpleAssays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SimpleList", "SummarizedExperiment::SimpleAssays", function(from) {
    convert(from, SimpleAssays)
})

methods::setAs("SummarizedExperiment::AssaysInEnv", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SimpleList", "SummarizedExperiment::AssaysInEnv", function(from) {
    convert(from, AssaysInEnv)
})

methods::setAs("SummarizedExperiment::RangedSummarizedExperiment", "SummarizedExperiment::SummarizedExperiment", function(from) {
    convert(from, SummarizedExperiment_class)
})

methods::setAs("SummarizedExperiment::SummarizedExperiment", "SummarizedExperiment::RangedSummarizedExperiment", function(from) {
    convert(from, RangedSummarizedExperiment)
})

methods::setAs("ExpressionSet", "SummarizedExperiment::RangedSummarizedExperiment", function(from) {
    convert(from, RangedSummarizedExperiment)
})

methods::setAs("ExpressionSet", "SummarizedExperiment::SummarizedExperiment", function(from) {
    convert(from, SummarizedExperiment_class)
})

methods::setAs("SummarizedExperiment::RangedSummarizedExperiment", "ExpressionSet", function(from) {
    convert(from, ExpressionSet_class)
})

methods::setAs("SummarizedExperiment::SummarizedExperiment", "ExpressionSet", function(from) {
    convert(from, ExpressionSet_class)
})
