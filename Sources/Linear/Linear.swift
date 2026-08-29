public import Spatial
public import Tagged

public enum Linear<Scalar: ~Copyable, Space>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

extension Linear {

    public typealias Dx = Displacement.X<Space>.Value<Scalar>

    public typealias Dy = Displacement.Y<Space>.Value<Scalar>

    public typealias Dz = Displacement.Z<Space>.Value<Scalar>

    public typealias Dw = Displacement.W<Space>.Value<Scalar>

    public typealias Magnitude = Spatial::Magnitude<Space>.Value<Scalar>

    public typealias Width = Extent.X<Space>.Value<Scalar>

    public typealias Height = Extent.Y<Space>.Value<Scalar>

    public typealias Depth = Extent.Z<Space>.Value<Scalar>
}

extension Linear {

    public typealias Length = Spatial::Length<Space, Scalar>

    public typealias Radius = Spatial::Radius<Space, Scalar>

    public typealias Diameter = Spatial::Diameter<Space, Scalar>

    public typealias Distance = Spatial::Distance<Space, Scalar>

    public typealias Circumference = Spatial::Circumference<Space, Scalar>

    public typealias Perimeter = Spatial::Perimeter<Space, Scalar>

    public typealias ArcLength = Spatial::ArcLength<Space, Scalar>

    public typealias Area = Spatial::Area<Space>.Value<Scalar>
}
