# S7 migration notes

Deferred while focusing on S4/S7 initialization:

- Constructors should eventually create instances through the S4 shim classes so
  existing `as()` methods and downstream S4 code see `SummarizedExperiment` and
  `RangedSummarizedExperiment` S4 instances.
- Get away from having _class objects. Each S7 class should be represented by a 
  class object of the same name as the class. This means having the current functions
  with those names becoming constructors on the S7 class. Even though they will actually
  create the S4 shims mentioned above, they should work, as long as we have a dummy call
  to new_object() somewhere in the constructor.

Current constructor compromises:

- The public `SummarizedExperiment` and `RangedSummarizedExperiment` bindings are
  now S7 class objects with custom constructors. The old high-level
  `SummarizedExperiment()` function moved behind the private
  `.SummarizedExperiment()` helper. The custom constructors include a dead
  `new_object()` call to satisfy S7's constructor checks even though the live path
  creates S4 shim instances.
- The low-level constructors allocate with `new2(..., check=FALSE)` and then set
  S4 slots directly with `methods::slot<-`. This is intentionally more manual than
  the original S4 constructor path. Calling `methods::new()` with slot arguments
  caused S4 validity/S7 property validation to run while the object was still in a
  partially initialized S4/S7 state.
- Nullable S4 slots are not smooth yet. S4 represents `NULL` in slots with an
  internal sentinel, and S7 property access currently sees that sentinel as a
  symbol rather than as `NULL`. To avoid exposing that through properties,
  constructors store a non-NULL empty value when possible: empty assays use
  `Assays(..., as.null.if.no.assay=FALSE)`, and absent `NAMES` are stored as
  `character(0)` with `names()` translating that back to `NULL`.
- The high-level constructor must preserve whether `colData` was supplied. The
  S7 constructor wrapper therefore forwards `colData` only when it was not
  missing; otherwise the old constructor logic can still infer `colData` from the
  assays.
- The constructor-time dimname check avoids calling `dimnames(ans)` on the newly
  constructed object. In the ranged case, that routed through the half-migrated
  S4/S7 dispatch stack and could recurse until the C stack overflowed. The check
  instead compares assays against the dimnames known from constructor inputs.
- Direct slot setting means this path bypasses ordinary property setters and
  relies on the values being normalized before assignment. Full validity remains
  something to revisit once nullable S4 slots and ranged `dim()`/`dimnames()`
  dispatch are less fragile.
