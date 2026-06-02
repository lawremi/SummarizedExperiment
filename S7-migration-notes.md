# S7 migration notes

Deferred while focusing on S4/S7 initialization:

- Constructors should eventually create instances through the S4 shim classes so
  existing `as()` methods and downstream S4 code see `SummarizedExperiment` and
  `RangedSummarizedExperiment` S4 instances.
- Direct S4 coercions such as `as(x, "SimpleList")` and
  `as(x, "ExpressionSet")` still expose the class-name mismatch when objects are
  pure S7 instances with qualified S3-style class vectors.
- Some tests still refer to internal class-object names such as
  `SummarizedExperiment_class`; these need a class-object/constructor naming
  decision.
