# swift-linear

Use this package when you do vector and matrix arithmetic inside a coordinate space (a drawing, a page, a scene). It keeps vectors from different spaces apart and returns typed quantities such as `Linear.Length`, `Linear.Distance`, `Linear.Area` and `Radian`. Start from `Linear.Vector<N>` and `Linear.Matrix<Rows, Columns>`. `Space` is a phantom tag (`Void` works). If the numbers belong to no space and you need no typed results, use the vector and matrix types of swift-vector and swift-matrix instead. `Linear` stores its values in them.

## Laws

- Matrices are row-major and act on column vectors. `Linear.Matrix.init(a:b:c:d:)` lays out rows `a b` and `c d`. In `m * v`, row i of `m` is dotted with `v`. In `a * b`, `b` is applied to a vector first.
- `a *= b` means `a = a * b`, so the new matrix is concatenated on the right.
- Degenerate inputs return a value and never trap:
  - `normalized` of a zero vector is `.zero`.
  - `projection(onto:)` a zero vector is `.zero`, so `rejection(from:)` a zero vector returns the vector unchanged.
  - `angle(to:)` with a zero-length operand is zero radians.
  - The 2×2 `inverse` is `nil`, and `isInvertible` is false, exactly when the determinant is 0.
  - The 2×2 `decomposition` is `nil` exactly when the first column is zero.
- Every zero test is an exact comparison with no tolerance. A nearly singular matrix still inverts, and a tiny vector still normalizes.
- `Linear.Matrix.rotation(_:)` is counterclockwise for positive angles (`a = cos`, `b = -sin`, `c = sin`, `d = cos`), and so is `rotated(by:)`.
  - `signedAngle(to:)` is positive counterclockwise, from `atan2(cross, dot)`.
  - `angle(to:)` is unsigned, from `acos`.
  - `angle` is `atan2(dy, dx)`.
- `rotation(cos:sin:)` takes any two values without checking that they lie on the unit circle.
- `map` visits each scalar exactly once, in index order (row by row for a matrix). It stops at the first thrown error and rethrows it with its own type. Empty shapes never call the transform.
- A vector encodes as a flat array. Decoding throws unless the array has exactly N elements of the scalar type. A 2×2 matrix encodes as the keyed object `{"a","b","c","d"}`.
- The angle operations need `Scalar: BinaryFloatingPoint & Trigonometry.Circular`. This package conforms no scalar type to `Trigonometry.Circular`, so the caller supplies that conformance (the tests conform `Double` through Foundation).
