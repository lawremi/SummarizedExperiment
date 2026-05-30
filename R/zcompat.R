### Since client code likely relies on coercions via as(), define them here

### TODO: complete this list

methods::setAs("SummarizedExperiment::Assays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SummarizedExperiment::SimpleAssays", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})

methods::setAs("SummarizedExperiment::AssaysInEnv", "SimpleList", function(from) {
    convert(from, SimpleList_class)
})
