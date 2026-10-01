public import Space
public import Tagged

public enum Linear<Scalar: ~Copyable, Space>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

extension Linear {

    public typealias Dx = Displacement.X<Space>.Value<Scalar>

    public typealias Dy = Displacement.Y<Space>.Value<Scalar>

    public typealias Dz = Displacement.Z<Space>.Value<Scalar>

    public typealias Dw = Displacement.W<Space>.Value<Scalar>

    public typealias Magnitude = Space::Magnitude<Space>.Value<Scalar>

    public typealias Width = Extent.X<Space>.Value<Scalar>

    public typealias Height = Extent.Y<Space>.Value<Scalar>

    public typealias Depth = Extent.Z<Space>.Value<Scalar>
}

extension Linear {

    public typealias Length = Space::Length<Space, Scalar>

    public typealias Radius = Space::Radius<Space, Scalar>

    public typealias Diameter = Space::Diameter<Space, Scalar>

    public typealias Distance = Space::Distance<Space, Scalar>

    public typealias Circumference = Space::Circumference<Space, Scalar>

    public typealias Perimeter = Space::Perimeter<Space, Scalar>

    public typealias ArcLength = Space::ArcLength<Space, Scalar>

    public typealias Area = Space::Area<Space>.Value<Scalar>
}
