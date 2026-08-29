public import Dimension
public import Dimension_Tagged
public import Tagged

public enum Linear<Scalar: ~Copyable, Space>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

extension Linear {

    public typealias Dx = Displacement.X<Space>.Value<Scalar>

    public typealias Dy = Displacement.Y<Space>.Value<Scalar>

    public typealias Dz = Displacement.Z<Space>.Value<Scalar>

    public typealias Dw = Displacement.W<Space>.Value<Scalar>

    public typealias Magnitude = Dimension.Magnitude<Space>.Value<Scalar>

    public typealias Width = Extent.X<Space>.Value<Scalar>

    public typealias Height = Extent.Y<Space>.Value<Scalar>

    public typealias Depth = Extent.Z<Space>.Value<Scalar>
}

extension Linear {

    public typealias Length = Dimension_Tagged::Length<Space, Scalar>

    public typealias Radius = Dimension_Tagged::Radius<Space, Scalar>

    public typealias Diameter = Dimension_Tagged::Diameter<Space, Scalar>

    public typealias Distance = Dimension_Tagged::Distance<Space, Scalar>

    public typealias Circumference = Dimension_Tagged::Circumference<Space, Scalar>

    public typealias Perimeter = Dimension_Tagged::Perimeter<Space, Scalar>

    public typealias ArcLength = Dimension_Tagged::ArcLength<Space, Scalar>

    public typealias Area = Dimension.Area<Space>.Value<Scalar>
}
