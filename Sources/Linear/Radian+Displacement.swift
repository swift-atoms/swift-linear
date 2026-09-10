public import Angle
public import Trigonometry
public import Spatial
public import Tagged

extension Tagged::Tagged
where Tag == Angle.Radian, Underlying: BinaryFloatingPoint & Trigonometry.Circular {

    @inlinable
    public static func atan2<Space>(
        y: Displacement.Y<Space>.Value<Underlying>,
        x: Displacement.X<Space>.Value<Underlying>
    ) -> Self {
        Self(_unchecked: Underlying.atan2(y.underlying, x.underlying))
    }
}
