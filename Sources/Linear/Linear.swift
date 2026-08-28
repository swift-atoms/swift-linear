public import Dimension

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

    public typealias Length = Dimension.Length<Space, Scalar>

    public typealias Radius = Dimension.Radius<Space, Scalar>

    public typealias Diameter = Dimension.Diameter<Space, Scalar>

    public typealias Distance = Dimension.Distance<Space, Scalar>

    public typealias Circumference = Dimension.Circumference<Space, Scalar>

    public typealias Perimeter = Dimension.Perimeter<Space, Scalar>

    public typealias ArcLength = Dimension.ArcLength<Space, Scalar>

    public typealias Area = Dimension.Area<Space>.Value<Scalar>
}
