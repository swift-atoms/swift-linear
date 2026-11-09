import Foundation
import Linear
import Testing
public import Trigonometry

extension Double: @retroactive Trigonometry.Circular {
    public static func sin(_ x: Double) -> Double { Foundation.sin(x) }
    public static func cos(_ x: Double) -> Double { Foundation.cos(x) }
    public static func tan(_ x: Double) -> Double { Foundation.tan(x) }
    public static func asin(_ x: Double) -> Double { Foundation.asin(x) }
    public static func acos(_ x: Double) -> Double { Foundation.acos(x) }
    public static func atan(_ x: Double) -> Double { Foundation.atan(x) }
    public static func atan2(_ y: Double, _ x: Double) -> Double { Foundation.atan2(y, x) }
}

private typealias Vector = Linear<Double, Void>.Vector<2>

@Test
func `Matrix rotation and angle extraction reuse the circular capability`() {
    typealias Matrix = Linear<Double, Void>.Matrix<2, 2>
    let angle = Radian(_unchecked: Double.pi / 3)
    let matrix = Matrix.rotation(angle)
    let parts = matrix.decomposition
    #expect(abs((parts?.rotation.underlying ?? .nan) - angle.underlying) < 1e-12)
    #expect(abs((parts?.scale.x ?? .nan) - 1) < 1e-12)
    #expect(abs((parts?.scale.y ?? .nan) - 1) < 1e-12)
    #expect(abs(parts?.shear ?? .nan) < 1e-12)
    #expect(abs(matrix.determinant - 1) < 1e-12)
}

@Test
func `Decomposition of a sheared matrix recovers rotation, scale and shear`() throws {
    typealias Matrix = Linear<Double, Void>.Matrix<2, 2>
    let angle = Radian(_unchecked: Double.pi / 5)
    let matrix = Matrix.rotation(angle) * Matrix.scale(x: 2, y: 3) * Matrix.shear(x: 0.5, y: 0)
    let parts = try #require(matrix.decomposition)
    #expect(abs(parts.rotation.underlying - angle.underlying) < 1e-12)
    #expect(abs(parts.scale.x - 2) < 1e-12)
    #expect(abs(parts.scale.y - 3) < 1e-12)
    #expect(abs(parts.shear - 0.5) < 1e-12)
    let rebuilt =
        Matrix.rotation(parts.rotation) * Matrix.scale(x: parts.scale.x, y: parts.scale.y)
        * Matrix.shear(x: parts.shear, y: 0)
    #expect(abs(rebuilt.a - matrix.a) < 1e-12)
    #expect(abs(rebuilt.b - matrix.b) < 1e-12)
    #expect(abs(rebuilt.c - matrix.c) < 1e-12)
    #expect(abs(rebuilt.d - matrix.d) < 1e-12)
}

@Test
func `Decomposition carries a reflection in the y scale and is nil for a zero first column`() throws {
    typealias Matrix = Linear<Double, Void>.Matrix<2, 2>
    let parts = try #require(Matrix.scale(x: 2, y: -4).decomposition)
    #expect(abs(parts.rotation.underlying) < 1e-12)
    #expect(parts.scale.x == 2)
    #expect(parts.scale.y == -4)
    #expect(parts.shear == 0)
    #expect(Matrix(a: 0, b: 1, c: 0, d: 1).decomposition == nil)
}

@Test
func `Polar construction requires only circular trigonometry`() {
    let vector = Vector.unit(at: Radian(_unchecked: Double.pi / 2))
    #expect(abs(vector.dx.underlying) < 1e-12)
    #expect(abs(vector.dy.underlying - 1) < 1e-12)
}

@Test
func `Signed angle uses the circular atan2 capability`() {
    let right = Vector(dx: 1, dy: 0)
    let down = Vector(dx: 0, dy: -1)
    #expect(abs(right.signedAngle(to: down).underlying + Double.pi / 2) < 1e-12)
}

@Test
func `Rotating by a quarter turn preserves the vector length`() {
    let vector = Vector(dx: 3, dy: 4)
    let rotated = vector.rotated(by: Radian(_unchecked: Double.pi / 2))
    #expect(abs(rotated.dx.underlying + 4) < 1e-12)
    #expect(abs(rotated.dy.underlying - 3) < 1e-12)
    #expect(abs(rotated.length.underlying - 5) < 1e-12)
}

@Test
func `Angle between parallel vectors is not NaN when rounding pushes the cosine past one`() {
    let vector = Vector(dx: 0.3468563115085088, dy: 0.6267339884069809)
    let same = vector.angle(to: vector)
    #expect(!same.underlying.isNaN)
    #expect(abs(same.underlying) < 1e-12)
    let opposite = Vector(dx: -0.3468563115085088, dy: -0.6267339884069809)
    let reversed = vector.angle(to: opposite)
    #expect(!reversed.underlying.isNaN)
    #expect(abs(reversed.underlying - Double.pi) < 1e-12)
}
