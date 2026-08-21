public import Dimension_Primitives

public enum Linear<Scalar: ~Copyable, Space>: ~Copyable {}

extension Linear: Copyable where Scalar: Copyable {}
extension Linear: Sendable where Scalar: Sendable {}

extension Linear {

    public typealias Dx = Displacement.X<Space>.Value<Scalar>

    public typealias Dy = Displacement.Y<Space>.Value<Scalar>

    public typealias Dz = Displacement.Z<Space>.Value<Scalar>

    public typealias Dw = Displacement.W<Space>.Value<Scalar>

    public typealias Magnitude = Dimension_Primitives.Magnitude<Space>.Value<Scalar>

    public typealias Width = Extent.X<Space>.Value<Scalar>

    public typealias Height = Extent.Y<Space>.Value<Scalar>

    public typealias Depth = Extent.Z<Space>.Value<Scalar>
}

extension Linear {

    public typealias Length = Dimension_Primitives.Length<Space, Scalar>

    public typealias Radius = Dimension_Primitives.Radius<Space, Scalar>

    public typealias Diameter = Dimension_Primitives.Diameter<Space, Scalar>

    public typealias Distance = Dimension_Primitives.Distance<Space, Scalar>

    public typealias Circumference = Dimension_Primitives.Circumference<Space, Scalar>

    public typealias Perimeter = Dimension_Primitives.Perimeter<Space, Scalar>

    public typealias ArcLength = Dimension_Primitives.ArcLength<Space, Scalar>

    public typealias Area = Dimension_Primitives.Area<Space>.Value<Scalar>
}
