# S7 migration notes

Constructor/class-object cleanup:

- Constructors create instances through the S4 shim classes so existing `as()`
  methods and downstream S4 code see `SummarizedExperiment` and
  `RangedSummarizedExperiment` S4 instances.
- The exported class objects now have the same names as their classes:
  `SummarizedExperiment` and `RangedSummarizedExperiment`. The old high-level
  `SummarizedExperiment()` function is now `.SummarizedExperiment()` behind the
  S7 class constructor.

Current constructor compromises:

- The public `SummarizedExperiment` and `RangedSummarizedExperiment` bindings are
  now S7 class objects with custom constructors. The old high-level
  `SummarizedExperiment()` function moved behind the private
  `.SummarizedExperiment()` helper. The custom constructors include a dead
  `new_object()` call to satisfy S7's constructor checks even though the live path
  creates S4 shim instances.
- The low-level constructors should allocate through `methods::new()` with slot
  arguments. If that fails while the S4/S7 bridge is incomplete, the fix belongs
  in S7 or methods rather than in package-local post-construction slot setting.
- Nullable S4 slots depend on S7 using the same internal sentinel as S4 for
  stored `NULL` values. With that in place, absent `NAMES` can be stored as
  `NULL` again and still read correctly through both S4 slot access and S7
  property access. Empty assays still use
  `Assays(..., as.null.if.no.assay=FALSE)` so the `assays` slot remains a
  concrete `Assays` object.
- The high-level constructor must preserve whether `colData` was supplied. The
  S7 constructor wrapper therefore forwards `colData` only when it was not
  missing; otherwise the old constructor logic can still infer `colData` from the
  assays.
- The constructor-time dimname check avoids calling `dimnames(ans)` on the newly
  constructed object. In the ranged case, that routed through the half-migrated
  S4/S7 dispatch stack and could recurse until the C stack overflowed. The check
  instead compares assays against the dimnames known from constructor inputs.
- `RectangularData` belongs in the S7 inheritance chain, through the
  `RectangularVector` parent bridge, not on the exported S4 compatibility
  class. S7 registration now creates the virtual S4 class that carries S7
  properties as slots for S4 subclasses.
- Slot prototypes for values like `colData`, `assays`, `NAMES`, and `rowRanges`
  are an S7 registration responsibility. The concrete exported S4 classes should
  not need package-local prototype patches for
  `methods::new("SummarizedExperiment")` or
  `methods::new("RangedSummarizedExperiment")`.
- Open S7/methods issue: `validObject()` recursively validates S4 superclasses
  by coercing to those superclass slices. With `RectangularData` in the S7/S4
  parent chain, that currently means validation reaches a stripped
  `RectangularVector` object that no longer has `assays` or `colData`, so
  inherited `RectangularData` validity cannot compute `dim(x)`.
- Full constructor validity remains something to revisit once the S4/S7
  construction boundary settles.
