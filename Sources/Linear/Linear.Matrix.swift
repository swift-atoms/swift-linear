public import Dimension
public import Real

extension Linear {

    public struct Matrix<let Rows: Int, let Columns: Int> {

        public var rows: InlineArray<Rows, InlineArray<Columns, Scalar>>

        @inlinable
        public init(rows: consuming InlineArray<Rows, InlineArray<Columns, Scalar>>) {
            self.rows = rows
        }
    }
}

extension Linear.Matrix: Sendable where Scalar: Sendable {}

extension Linear.Matrix {

    @inlinable
    public subscript(row: Int, column: Int) -> Scalar {
        get { rows[row][column] }
        set { rows[row][column] = newValue }
    }

    @inlinable
    public subscript(row row: Int) -> InlineArray<Columns, Scalar> {
        get { rows[row] }
        set { rows[row] = newValue }
    }
}

extension Linear.Matrix: Equatable where Scalar: Equatable {

    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<Rows {
            for j in 0..<Columns {
                if lhs.rows[i][j] != rhs.rows[i][j] {
                    return false
                }
            }
        }
        return true
    }
}

extension Linear.Matrix: Hashable where Scalar: Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<Rows {
            for j in 0..<Columns {
                hasher.combine(rows[i][j])
            }
        }
    }
}

extension Linear {

    public typealias Matrix2x2 = Matrix<2, 2>

    public typealias Matrix3x3 = Matrix<3, 3>

    public typealias Matrix4x4 = Matrix<4, 4>
}

extension Linear.Matrix where Scalar: AdditiveArithmetic {

    @inlinable
    public static var zero: Self {
        Self(rows: InlineArray(repeating: InlineArray(repeating: .zero)))
    }
}

extension Linear.Matrix
where Rows == Columns, Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {

    @inlinable
    public static var identity: Self {
        var rows = InlineArray<Rows, InlineArray<Columns, Scalar>>(
            repeating: InlineArray(repeating: .zero)
        )
        for i in 0..<Rows {
            rows[i][i] = 1
        }
        return Self(rows: rows)
    }
}

extension Linear.Matrix {

    @inlinable
    public static func transpose(_ matrix: Self) -> Linear.Matrix<Columns, Rows> {
        var result = InlineArray<Columns, InlineArray<Rows, Scalar>>(
            repeating: InlineArray(repeating: matrix.rows[0][0])
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[j][i] = matrix.rows[i][j]
            }
        }
        return Linear.Matrix<Columns, Rows>(rows: result)
    }

    @inlinable
    public var transpose: Linear.Matrix<Columns, Rows> {
        Self.transpose(self)
    }
}

extension Linear.Matrix where Rows == Columns, Scalar: AdditiveArithmetic {

    @inlinable
    public static func trace(_ matrix: Self) -> Scalar {
        var sum: Scalar = .zero
        for i in 0..<Rows {
            sum += matrix[i, i]
        }
        return sum
    }

    @inlinable
    public var trace: Scalar {
        Self.trace(self)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2 {

    @inlinable
    public var a: Scalar {
        get { rows[0][0] }
        set { rows[0][0] = newValue }
    }

    @inlinable
    public var b: Scalar {
        get { rows[0][1] }
        set { rows[0][1] = newValue }
    }

    @inlinable
    public var c: Scalar {
        get { rows[1][0] }
        set { rows[1][0] = newValue }
    }

    @inlinable
    public var d: Scalar {
        get { rows[1][1] }
        set { rows[1][1] = newValue }
    }

    @inlinable
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar) {
        self.init(rows: [[a, b], [c, d]])
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: Swift.Numeric {

    @inlinable
    public static func determinant(_ matrix: Self) -> Scalar {
        matrix.a * matrix.d - matrix.b * matrix.c
    }

    @inlinable
    public var determinant: Scalar {
        Self.determinant(self)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {

    @inlinable
    public static func isInvertible(_ matrix: Self) -> Bool {
        determinant(matrix) != 0
    }

    @inlinable
    public var isInvertible: Bool {
        Self.isInvertible(self)
    }

    @inlinable
    public static func inverse(_ matrix: Self) -> Self? {
        let det = determinant(matrix)
        guard det != 0 else { return nil }
        let invDet: Scalar = 1 / det
        return Self(
            a: matrix.d * invDet,
            b: -matrix.b * invDet,
            c: -matrix.c * invDet,
            d: matrix.a * invDet
        )
    }

    @inlinable
    public var inverse: Self? {
        Self.inverse(self)
    }
}

#if !hasFeature(Embedded)
    extension Linear.Matrix: Codable where Rows == 2, Columns == 2, Scalar: Codable {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            self.init(a: a, b: b, c: c, d: d)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(a, forKey: .a)
            try container.encode(b, forKey: .b)
            try container.encode(c, forKey: .c)
            try container.encode(d, forKey: .d)
        }
    }
#endif

extension Linear.Matrix
where Rows == 2, Columns == 2, Scalar: FloatingPoint {

    @inlinable
    public static func scale(_ factor: Scale<1, Scalar>) -> Self {
        Self(a: factor.value, b: 0, c: 0, d: factor.value)
    }

    @inlinable
    public static func scale(x: Scalar, y: Scalar) -> Self {
        Self(a: x, b: 0, c: 0, d: y)
    }

    @inlinable
    public static func shear(x: Scalar, y: Scalar) -> Self {
        Self(a: 1, b: x, c: y, d: 1)
    }
}

extension Linear.Matrix
where Rows == 2, Columns == 2, Scalar: SignedNumeric {

    @inlinable
    public static func rotation(cos: Scalar, sin: Scalar) -> Self {
        Self(a: cos, b: -sin, c: sin, d: cos)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar == Double {

    @inlinable
    public static func rotation(_ angle: Radian<Scalar>) -> Self {
        rotation(cos: angle.cos.value, sin: angle.sin.value)
    }

    @inlinable
    public static func rotation(_ angle: Degree<Scalar>) -> Self {
        rotation(angle.radians)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar == Float {

    @inlinable
    public static func rotation(_ angle: Radian<Scalar>) -> Self {
        rotation(cos: angle.cos.value, sin: angle.sin.value)
    }

    @inlinable
    public static func rotation(_ angle: Degree<Scalar>) -> Self {
        rotation(angle.radians)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar == Double {

    @inlinable
    public static func rotationAngle(_ matrix: Self) -> Dimension.Radian<Scalar> {
        Radian(_unchecked: Scalar.math.atan2(matrix.c, matrix.a))
    }

    @inlinable
    public var rotationAngle: Dimension.Radian<Scalar> {
        Self.rotationAngle(self)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {

    @inlinable
    public static func scaleFactors(_ matrix: Self) -> (x: Scalar, y: Scalar) {
        let sx = (matrix.a * matrix.a + matrix.c * matrix.c).squareRoot()
        let sy = (matrix.b * matrix.b + matrix.d * matrix.d).squareRoot()
        return (sx, sy)
    }

    @inlinable
    public var scaleFactors: (x: Scalar, y: Scalar) {
        Self.scaleFactors(self)
    }
}

extension Linear.Matrix where Rows == 3, Columns == 3, Scalar: Swift.Numeric {

    @inlinable
    public static func determinant(_ matrix: Self) -> Scalar {
        let a = matrix[0, 0]
        let b = matrix[0, 1]
        let c = matrix[0, 2]
        let d = matrix[1, 0]
        let e = matrix[1, 1]
        let f = matrix[1, 2]
        let g = matrix[2, 0]
        let h = matrix[2, 1]
        let i = matrix[2, 2]

        let cofactor0 = e * i - f * h
        let cofactor1 = d * i - f * g
        let cofactor2 = d * h - e * g

        return a * cofactor0 - b * cofactor1 + c * cofactor2
    }

    @inlinable
    public var determinant: Scalar {
        Self.determinant(self)
    }
}

extension Linear.Matrix {

    @inlinable
    public func map<Result, E: Swift.Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result, Space>.Matrix<Rows, Columns> {
        var result = InlineArray<Rows, InlineArray<Columns, Result>>(
            repeating: InlineArray(repeating: try transform(rows[0][0]))
        )
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = try transform(rows[i][j])
            }
        }
        return Linear<Result, Space>.Matrix<Rows, Columns>(rows: result)
    }
}
