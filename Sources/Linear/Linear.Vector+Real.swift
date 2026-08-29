public import Dimension
public import Dimension_Tagged
internal import Real
public import Tagged

extension Linear.Vector where N == 2, Scalar: BinaryFloatingPoint & Numeric.Transcendental {

    @inlinable
    public static func angle(_ vector: Self) -> Radian<Scalar> {
        .atan2(y: vector.dy, x: vector.dx)
    }

    @inlinable
    public var angle: Radian<Scalar> {
        Self.angle(self)
    }

    @inlinable
    public static func unit(at angle: Radian<Scalar>) -> Self {
        Self(dx: Linear.Dx(_unchecked: angle.cos.value), dy: Linear.Dy(_unchecked: angle.sin.value))
    }

    @inlinable
    public static func polar(length: Linear.Length, angle: Radian<Scalar>) -> Self {
        let r = length.underlying
        return Self(
            dx: Linear.Dx(_unchecked: r * angle.cos.value),
            dy: Linear.Dy(_unchecked: r * angle.sin.value)
        )
    }

    @inlinable
    public static func angle(_ lhs: Self, to rhs: Self) -> Radian<Scalar> {
        let dotProduct = dot(lhs, rhs)
        let magnitudes = lhs.length.underlying * rhs.length.underlying
        guard magnitudes > 0 else { return .zero }
        return .acos(Scale(dotProduct / magnitudes))
    }

    @inlinable
    public func angle(to other: Self) -> Radian<Scalar> {
        Self.angle(self, to: other)
    }

    @inlinable
    public static func signedAngle(_ lhs: Self, to rhs: Self) -> Radian<Scalar> {
        Radian(_unchecked: Scalar._atan2(Self.cross(lhs, rhs).underlying, dot(lhs, rhs)))
    }

    @inlinable
    public func signedAngle(to other: Self) -> Radian<Scalar> {
        Self.signedAngle(self, to: other)
    }

    @inlinable
    public static func rotated(_ vector: Self, by angle: Radian<Scalar>) -> Self {
        let c = angle.cos.value
        let s = angle.sin.value
        let x = vector.dx.underlying
        let y = vector.dy.underlying
        return Self(
            dx: Linear.Dx(_unchecked: x * c - y * s),
            dy: Linear.Dy(_unchecked: x * s + y * c)
        )
    }

    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    @inlinable
    public static func rotated(_ vector: Self, by angle: Degree<Scalar>) -> Self {
        rotated(vector, by: angle.radians)
    }

    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }
}
