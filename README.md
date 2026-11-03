# swift-linear

Use `Linear` when you do vector and matrix arithmetic that belongs to a coordinate space (a drawing, a page, a scene) and want the compiler to keep vectors from different spaces apart and to hand back typed results: `Dx`/`Dy` components, a `Length`, a `Distance`, an `Area`, a `Radian`. If the numbers belong to no space and need no typed results, use the untagged `Vector` and `Matrix` from swift-vector and swift-matrix instead; `Linear` stores its values in them.

## Model

`Linear<Scalar, Space>` is an uninhabited namespace. `Space` is a phantom tag (any type, `Void` included), so two `Vector<2>` types with the same `Scalar` and different `Space` tags are different types. Everything is a value type; copies are independent.

- `Vector<N>` (`Vector2`, `Vector3`, `Vector4`): built from an `InlineArray<N, Scalar>` or, for N = 2, 3, 4, from typed components (`init(dx:dy:)`, `init(dx:dy:dz:)`, `init(_:dz:)`, …). Read and write through `components`, `[i]`, or `dx`/`dy`/`dz`/`dw`.
- `Matrix<Rows, Columns>` (`Matrix2x2`, `Matrix3x3`, `Matrix4x4`): built from `rows:`, or `init(a:b:c:d:)` for 2×2 (row-major: `a b` / `c d`). Read and write through `rows`, `[row, column]`, `[row:]`, and `a`…`d` on 2×2.
- Vector operations return new values: `+`, `-`, prefix `-`, `*` and `/` by a `Scale<1, Scalar>`, `dot`, `projection(onto:)`, `rejection(from:)`, `normalized`, `zip`, `map`. `length` returns `Linear.Length`, `distance(to:)` returns `Linear.Distance`, 2D `cross` returns `Linear.Area`, 3D `cross` returns a vector.
- Matrix operations: `+`, `-`, prefix `-`, `matrix * vector`, `matrix * matrix` / `multiplied(by:)` (shapes checked at compile time), `transpose`, `trace`, `identity`, `zero`, `map`; `determinant` for 2×2 and 3×3; `inverse`, `scale`, `shear`, `rotation`, `rotationAngle`, `scaleFactors` for 2×2.
- `map` changes the scalar type and keeps the space: `Linear<Result, Space>.Vector<N>` or `.Matrix<Rows, Columns>`.

## Rules

- Degenerate inputs return a value, never trap: `normalized` of a zero vector, `projection(onto:)` a zero vector, and `angle(to:)` with a zero vector return zero. 2×2 `inverse` returns `nil` when the determinant is 0.
- `a *= b` means `a = a * b`: the new matrix is concatenated on the right.
- `map` visits each scalar once, in index order (row by row for a matrix), stops at the first thrown error and rethrows it with its own type. Empty shapes never call the transform.
- Plain-scalar `*` and `/` on vectors are not public; scale a vector by a `Scale<1, Scalar>`, and a matrix with `map`.
- A vector encodes as a flat array; decoding throws `DecodingError` unless the array has exactly N elements of the scalar type. A 2×2 matrix encodes as the keyed object `{"a","b","c","d"}`; other matrix shapes are not `Codable`.
- Angles and rotations (`angle`, `angle(to:)`, `signedAngle(to:)`, `unit(at:)`, `polar(length:angle:)`, `rotated(by:)`, `Matrix.rotation(_:)`, `rotationAngle`) need `Scalar: BinaryFloatingPoint & Trigonometry.Circular`, and accept `Radian` or `Degree`. This package conforms no scalar type to `Trigonometry.Circular`; supply that conformance yourself.

## Example

```swift
typealias Matrix = Linear<Double, Void>.Matrix2x2
typealias Vector = Linear<Double, Void>.Vector2

let m = Matrix(a: 1, b: 2, c: 3, d: 4)
let v = m * Vector(dx: 1, dy: 1)   // dx == 3, dy == 7
m.determinant                      // -2
Matrix(a: 1, b: 2, c: 2, d: 4).inverse  // nil
```
