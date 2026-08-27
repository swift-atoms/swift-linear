public import Dimension
public import Numeric_Standard_Library_Integration
public import Tagged

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
