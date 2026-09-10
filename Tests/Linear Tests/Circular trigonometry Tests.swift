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
    #expect(abs(matrix.rotationAngle.underlying - angle.underlying) < 1e-12)
    #expect(abs(matrix.determinant - 1) < 1e-12)
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
