import Testing

import Tagged

@testable import Linear

@Suite
struct `Linear.Matrix Tests` {
    typealias Mat2x2 = Linear<Double, Void>.Matrix2x2
    typealias Mat3x3 = Linear<Double, Void>.Matrix3x3
    typealias Vec2 = Linear<Double, Void>.Vector<2>

    @Test
    func `2x2 matrix construction with a,b,c,d`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.a == 1)
        #expect(m.b == 2)
        #expect(m.c == 3)
        #expect(m.d == 4)
    }

    @Test
    func `Subscript access`() {
        var m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m[0, 0] == 1)
        #expect(m[0, 1] == 2)
        #expect(m[1, 0] == 3)
        #expect(m[1, 1] == 4)

        m[0, 1] = 10
        #expect(m[0, 1] == 10)
    }

    @Test
    func `Identity matrix`() {
        let id = Mat2x2.identity
        #expect(id.a == 1)
        #expect(id.b == 0)
        #expect(id.c == 0)
        #expect(id.d == 1)
    }

    @Test
    func `3x3 identity matrix`() {
        let id = Mat3x3.identity
        #expect(id[0, 0] == 1)
        #expect(id[0, 1] == 0)
        #expect(id[1, 1] == 1)
        #expect(id[2, 2] == 1)
    }

    @Test
    func `Zero matrix`() {
        let zero = Mat2x2.zero
        #expect(zero.a == 0)
        #expect(zero.b == 0)
        #expect(zero.c == 0)
        #expect(zero.d == 0)
    }

    @Test
    func `Matrix addition`() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let sum = a + b
        #expect(sum.a == 6)
        #expect(sum.b == 8)
        #expect(sum.c == 10)
        #expect(sum.d == 12)
    }

    @Test
    func `Matrix subtraction`() {
        let a = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let b = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let diff = a - b
        #expect(diff.a == 4)
        #expect(diff.b == 4)
        #expect(diff.c == 4)
        #expect(diff.d == 4)
    }

    @Test
    func `Scalar multiplication`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let scaled = m.map { $0 * 2 }
        #expect(scaled.a == 2)
        #expect(scaled.b == 4)
        #expect(scaled.c == 6)
        #expect(scaled.d == 8)
    }

    @Test
    func `Negation`() {
        let m = Mat2x2(a: 1, b: -2, c: 3, d: -4)
        let neg = -m
        #expect(neg.a == -1)
        #expect(neg.b == 2)
        #expect(neg.c == -3)
        #expect(neg.d == 4)
    }

    @Test
    func `Matrix-vector multiplication`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let v = Vec2(dx: .init(_unchecked: 1), dy: .init(_unchecked: 1))
        let result = m * v
        #expect(result.dx.underlying == 3)
        #expect(result.dy.underlying == 7)
    }

    @Test
    func `Matrix-matrix multiplication`() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 5, b: 6, c: 7, d: 8)
        let result = a.multiplied(by: b)

        #expect(result.a == 19)
        #expect(result.b == 22)
        #expect(result.c == 43)
        #expect(result.d == 50)
    }

    @Test
    func `Identity multiplication`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let id = Mat2x2.identity
        let result = m.multiplied(by: id)
        #expect(result == m)
    }

    @Test
    func `Transpose`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let t = m.transpose
        #expect(t.a == 1)
        #expect(t.b == 3)
        #expect(t.c == 2)
        #expect(t.d == 4)
    }

    @Test
    func `2x2 determinant`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.determinant == -2)
    }

    @Test
    func `3x3 determinant`() {

        var m = Mat3x3.zero
        m[0, 0] = 1
        m[0, 1] = 2
        m[0, 2] = 3
        m[1, 0] = 4
        m[1, 1] = 5
        m[1, 2] = 6
        m[2, 0] = 7
        m[2, 1] = 8
        m[2, 2] = 9
        #expect(m.determinant == 0)
    }

    @Test
    func `3x3 non-singular determinant`() {

        var m = Mat3x3.zero
        m[0, 0] = 1
        m[1, 1] = 2
        m[2, 2] = 3
        #expect(m.determinant == 6)
    }

    @Test
    func `2x2 inverse`() {
        let m = Mat2x2(a: 4, b: 7, c: 2, d: 6)

        guard let inv = m.inverse else {
            #expect(Bool(false), "Matrix should be invertible")
            return
        }
        #expect(abs(inv.a - 0.6) < 1e-10)
        #expect(abs(inv.b - (-0.7)) < 1e-10)
        #expect(abs(inv.c - (-0.2)) < 1e-10)
        #expect(abs(inv.d - 0.4) < 1e-10)
    }

    @Test
    func `Singular matrix has no inverse`() {
        let m = Mat2x2(a: 1, b: 2, c: 2, d: 4)
        #expect(m.inverse == nil)
    }

    @Test
    func `Inverse * original = identity`() {
        let m = Mat2x2(a: 4, b: 7, c: 2, d: 6)
        guard let inv = m.inverse else {
            #expect(Bool(false), "Matrix should be invertible")
            return
        }
        let product = m.multiplied(by: inv)
        #expect(abs(product.a - 1) < 1e-10)
        #expect(abs(product.b) < 1e-10)
        #expect(abs(product.c) < 1e-10)
        #expect(abs(product.d - 1) < 1e-10)
    }

    @Test
    func `Trace`() {
        let m = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        #expect(m.trace == 5)
    }

    @Test
    func `3x3 trace`() {
        var m = Mat3x3.zero
        m[0, 0] = 1
        m[1, 1] = 2
        m[2, 2] = 3
        #expect(m.trace == 6)
    }

    @Test
    func `Matrix equality`() {
        let a = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let b = Mat2x2(a: 1, b: 2, c: 3, d: 4)
        let c = Mat2x2(a: 1, b: 2, c: 3, d: 5)
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func `Non-square matrix multiplication`() {

        let m23: Linear<Double, Void>.Matrix<2, 3> = .init(rows: [
            [1, 2, 3],
            [4, 5, 6],
        ])
        let m32: Linear<Double, Void>.Matrix<3, 2> = .init(rows: [
            [1, 2],
            [3, 4],
            [5, 6],
        ])
        let result: Linear<Double, Void>.Matrix<2, 2> = m23.multiplied(by: m32)

        #expect(result[0, 0] == 22)
        #expect(result[0, 1] == 28)
        #expect(result[1, 0] == 49)
        #expect(result[1, 1] == 64)
    }
}
