public import Dimension

@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] * rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

@inlinable
public func * <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Scale<1, Scalar>,
    rhs: Linear<Scalar, Space>.Vector<N>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = rhs.components
    for i in 0..<N {
        result[i] = lhs.value * rhs.components[i]
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

@inlinable
public func / <Scalar: FloatingPoint, Space, let N: Int>(
    lhs: Linear<Scalar, Space>.Vector<N>,
    rhs: Scale<1, Scalar>
) -> Linear<Scalar, Space>.Vector<N> {
    var result = lhs.components
    for i in 0..<N {
        result[i] = lhs.components[i] / rhs.value
    }
    return Linear<Scalar, Space>.Vector<N>(result)
}

extension Linear.Matrix where Scalar: Swift.Numeric {

    @inlinable
    public static func * (lhs: borrowing Self, rhs: Linear.Vector<Columns>) -> Linear.Vector<Rows> {
        var result = InlineArray<Rows, Scalar>(repeating: .zero)
        for i in 0..<Rows {
            var sum: Scalar = .zero
            for j in 0..<Columns {
                sum += lhs[i, j] * rhs.components[j]
            }
            result[i] = sum
        }
        return Linear.Vector<Rows>(result)
    }
}

extension Linear.Matrix where Scalar: Swift.Numeric {

    @inlinable
    public func multiplied<let P: Int>(by rhs: Linear.Matrix<Columns, P>) -> Linear.Matrix<Rows, P>
    {
        var result = InlineArray<Rows, InlineArray<P, Scalar>>(
            repeating: InlineArray(repeating: .zero)
        )
        for i in 0..<Rows {
            for j in 0..<P {
                var sum: Scalar = .zero
                for k in 0..<Columns {
                    sum += self[i, k] * rhs[k, j]
                }
                result[i][j] = sum
            }
        }
        return Linear.Matrix<Rows, P>(rows: result)
    }

    @inlinable
    public static func * <let P: Int>(
        lhs: Self,
        rhs: Linear.Matrix<Columns, P>
    ) -> Linear.Matrix<Rows, P> {
        lhs.multiplied(by: rhs)
    }
}

extension Linear.Matrix where Rows == 2, Columns == 2, Scalar: FloatingPoint {

    @inlinable
    public static func * (
        lhs: Self,
        rhs: Linear<Scalar, Space>.Vector<2>
    ) -> Linear<Scalar, Space>.Vector<2> {
        let x = lhs.a * rhs.dx.underlying + lhs.b * rhs.dy.underlying
        let y = lhs.c * rhs.dx.underlying + lhs.d * rhs.dy.underlying
        return Linear<Scalar, Space>.Vector(dx: .init(_unchecked: x), dy: .init(_unchecked: y))
    }
}

extension Linear.Vector where Scalar: FloatingPoint {

    @inlinable
    package static func * (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] * rhs
        }
        return Self(result)
    }

    @inlinable
    package static func / (lhs: borrowing Self, rhs: Scalar) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] / rhs
        }
        return Self(result)
    }
}

extension Linear.Matrix where Scalar: SignedNumeric {

    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = -value.rows[i][j]
            }
        }
        return Self(rows: result)
    }
}

extension Linear.Matrix where Scalar: AdditiveArithmetic {

    @inlinable
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = lhs.rows[i][j] + rhs.rows[i][j]
            }
        }
        return Self(rows: result)
    }

    @inlinable
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.rows
        for i in 0..<Rows {
            for j in 0..<Columns {
                result[i][j] = lhs.rows[i][j] - rhs.rows[i][j]
            }
        }
        return Self(rows: result)
    }
}

extension Linear.Vector where Scalar: SignedNumeric {

    @inlinable
    @_disfavoredOverload
    public static prefix func - (value: borrowing Self) -> Self {
        var result = value.components
        for i in 0..<N {
            result[i] = -value.components[i]
        }
        return Self(result)
    }
}

extension Linear.Vector where Scalar: AdditiveArithmetic {

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] + rhs.components[i]
        }
        return Self(result)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        var result = lhs.components
        for i in 0..<N {
            result[i] = lhs.components[i] - rhs.components[i]
        }
        return Self(result)
    }
}

@inlinable
public func dot<Scalar: Swift.Numeric, Space, let N: Int>(
    _ lhs: Linear<Scalar, Space>.Vector<N>,
    _ rhs: Linear<Scalar, Space>.Vector<N>
) -> Scalar {
    var sum: Scalar = .zero
    for i in 0..<N {
        sum += lhs.components[i] * rhs.components[i]
    }
    return sum
}

@inlinable
public func dot<Scalar: Swift.Numeric, Space>(
    _ lhs: Linear<Scalar, Space>.Vector<2>,
    _ rhs: Linear<Scalar, Space>.Vector<2>
) -> Scalar {
    lhs.dx.underlying * rhs.dx.underlying + lhs.dy.underlying * rhs.dy.underlying
}

@inlinable
public func cross<Scalar: Swift.Numeric, Space>(
    _ lhs: Linear<Scalar, Space>.Vector<2>,
    _ rhs: Linear<Scalar, Space>.Vector<2>
) -> Scalar {
    lhs.dx.underlying * rhs.dy.underlying - lhs.dy.underlying * rhs.dx.underlying
}
