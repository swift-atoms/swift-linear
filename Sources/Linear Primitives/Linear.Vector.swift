public import Dimension_Primitives

extension Linear {

    public struct Vector<let N: Int> {
        @usableFromInline
        internal var _components: InlineArray<N, Scalar>

        @inlinable
        public var components: InlineArray<N, Scalar> {
            get { _components }
            set { _components = newValue }
        }

        @inlinable
        public init(_ components: consuming InlineArray<N, Scalar>) {
            self._components = components
        }
    }
}

extension Linear.Vector: Sendable where Scalar: Sendable {}

extension Linear.Vector: Equatable where Scalar: Equatable {

    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.components[i] != rhs.components[i] {
                return false
            }
        }
        return true
    }
}

extension Linear.Vector: Hashable where Scalar: Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        for i in 0..<N {
            hasher.combine(components[i])
        }
    }
}

extension Linear {

    public typealias Vector2 = Vector<2>

    public typealias Vector3 = Vector<3>

    public typealias Vector4 = Vector<4>
}

#if !hasFeature(Embedded)
    extension Linear.Vector: Codable where Scalar: Codable {

        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var components = InlineArray<N, Scalar>(repeating: try container.decode(Scalar.self))
            for i in 1..<N {
                components[i] = try container.decode(Scalar.self)
            }
            self.init(components)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(components[i])
            }
        }
    }
#endif

extension Linear.Vector {

    @inlinable
    public subscript(index: Int) -> Scalar {
        get { components[index] }
        set { components[index] = newValue }
    }
}

extension Linear.Vector {

    @inlinable
    public init<U, E: Swift.Error>(
        _ other: borrowing Linear<U, Space>.Vector<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var comps = InlineArray<N, Scalar>(repeating: try transform(other.components[0]))
        for i in 1..<N {
            comps[i] = try transform(other.components[i])
        }
        self.init(comps)
    }

    @inlinable
    public func map<Result, E: Swift.Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Linear<Result, Space>.Vector<N> {
        var result = InlineArray<N, Result>(repeating: try transform(components[0]))
        for i in 1..<N {
            result[i] = try transform(components[i])
        }
        return Linear<Result, Space>.Vector<N>(result)
    }
}

extension Linear.Vector where Scalar: AdditiveArithmetic {

    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

extension Linear.Vector where Scalar: FloatingPoint {

    @inlinable
    public static func lengthSquared(_ vector: Self) -> Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += vector.components[i] * vector.components[i]
        }
        return sum
    }

    @inlinable
    public var lengthSquared: Scalar {
        Self.lengthSquared(self)
    }

    @inlinable
    public static func length(_ vector: Self) -> Linear.Length {
        Linear.Length(_unchecked: lengthSquared(vector).squareRoot())
    }

    @inlinable
    public var length: Linear.Length {
        Self.length(self)
    }

    @inlinable
    public static func normalized(_ vector: Self) -> Self {
        let len = length(vector).underlying
        guard len > 0 else { return .zero }
        return vector / len
    }

    @inlinable
    public var normalized: Self {
        Self.normalized(self)
    }
}

extension Linear.Vector where Scalar: FloatingPoint {

    @inlinable
    public static func dot(_ lhs: Self, _ rhs: Self) -> Scalar {
        var sum = Scalar.zero
        for i in 0..<N {
            sum += lhs.components[i] * rhs.components[i]
        }
        return sum
    }

    @inlinable
    public func dot(_ other: borrowing Self) -> Scalar {
        Self.dot(self, other)
    }

    @inlinable
    public static func projection(_ vector: Self, onto other: Self) -> Self {
        let otherLenSq = lengthSquared(other)
        guard otherLenSq > 0 else { return .zero }
        let scale = dot(vector, other) / otherLenSq
        return other * scale
    }

    @inlinable
    public func projection(onto other: borrowing Self) -> Self {
        Self.projection(self, onto: other)
    }

    @inlinable
    public static func rejection(_ vector: Self, from other: Self) -> Self {
        vector - projection(vector, onto: other)
    }

    @inlinable
    public func rejection(from other: borrowing Self) -> Self {
        Self.rejection(self, from: other)
    }

    @inlinable
    public static func distance(_ lhs: Self, to rhs: Self) -> Linear.Distance {
        Linear.Distance(_unchecked: length(lhs - rhs).underlying)
    }

    @inlinable
    public func distance(to other: borrowing Self) -> Linear.Distance {
        Self.distance(self, to: other)
    }
}

extension Linear.Vector where N == 2 {

    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(_unchecked: components[0]) }
        set { components[0] = newValue.underlying }
    }

    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(_unchecked: components[1]) }
        set { components[1] = newValue.underlying }
    }

    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy) {
        self.init([dx.underlying, dy.underlying])
    }
}

extension Linear.Vector where N == 2, Scalar: SignedNumeric {

    @inlinable
    public static func cross(_ lhs: Self, _ rhs: Self) -> Linear.Area {
        lhs.dx * rhs.dy - lhs.dy * rhs.dx
    }

    @inlinable
    public func cross(_ other: borrowing Self) -> Linear.Area {
        Self.cross(self, other)
    }
}

extension Linear.Vector where N == 3 {

    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(_unchecked: components[0]) }
        set { components[0] = newValue.underlying }
    }

    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(_unchecked: components[1]) }
        set { components[1] = newValue.underlying }
    }

    @inlinable
    public var dz: Linear.Dz {
        get { Linear.Dz(_unchecked: components[2]) }
        set { components[2] = newValue.underlying }
    }

    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy, dz: Linear.Dz) {
        self.init([dx.underlying, dy.underlying, dz.underlying])
    }

    @inlinable
    public init(_ vector2: Linear.Vector<2>, dz: Linear.Dz) {
        self.init([vector2.dx.underlying, vector2.dy.underlying, dz.underlying])
    }
}

extension Linear.Vector where N == 3, Scalar: SignedNumeric {

    @inlinable
    public static func cross(_ lhs: Self, _ rhs: Self) -> Self {
        let lx = lhs.dx.underlying
        let ly = lhs.dy.underlying
        let lz = lhs.dz.underlying
        let rx = rhs.dx.underlying
        let ry = rhs.dy.underlying
        let rz = rhs.dz.underlying
        return Self(
            dx: Linear.Dx(_unchecked: ly * rz - lz * ry),
            dy: Linear.Dy(_unchecked: lz * rx - lx * rz),
            dz: Linear.Dz(_unchecked: lx * ry - ly * rx)
        )
    }

    @inlinable
    public func cross(_ other: borrowing Self) -> Self {
        Self.cross(self, other)
    }
}

extension Linear.Vector where N == 4 {

    @inlinable
    public var dx: Linear.Dx {
        get { Linear.Dx(_unchecked: components[0]) }
        set { components[0] = newValue.underlying }
    }

    @inlinable
    public var dy: Linear.Dy {
        get { Linear.Dy(_unchecked: components[1]) }
        set { components[1] = newValue.underlying }
    }

    @inlinable
    public var dz: Linear.Dz {
        get { Linear.Dz(_unchecked: components[2]) }
        set { components[2] = newValue.underlying }
    }

    @inlinable
    public var dw: Linear.Dw {
        get { Linear.Dw(_unchecked: components[3]) }
        set { components[3] = newValue.underlying }
    }

    @inlinable
    public init(dx: Linear.Dx, dy: Linear.Dy, dz: Linear.Dz, dw: Linear.Dw) {
        self.init([dx.underlying, dy.underlying, dz.underlying, dw.underlying])
    }

    @inlinable
    public init(_ vector3: Linear.Vector<3>, dw: Linear.Dw) {
        self.init([
            vector3.dx.underlying, vector3.dy.underlying, vector3.dz.underlying, dw.underlying,
        ])
    }
}

extension Linear.Vector {

    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.components
        for i in 0..<N {
            result[i] = combine(a.components[i], b.components[i])
        }
        return Self(result)
    }
}
