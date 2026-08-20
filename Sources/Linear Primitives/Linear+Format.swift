// Linear+Formatting.swift
// Formatting extensions for Linear displacement types.

public import Dimension_Primitives
public import Format_Primitives
import Formatter_Primitives

// MARK: - Tagged + formatted()

extension Tagged where Underlying: BinaryFloatingPoint {
    /// Formats this tagged value using the given formatter.
    ///
    /// Works with any displacement type (Dx, Dy, Dz, Dw) or magnitude.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dx: Linear<Double>.Dx<Void> = .init(72.5)
    /// dx.formatted(.number)  // "72.5"
    ///
    /// let length: Linear<Double>.Magnitude<Void> = .init(100.5)
    /// length.formatted(.number)  // "100.5"
    /// ```
    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.`Protocol`, F.Input: BinaryFloatingPoint, F.Failure == Never {
        format.format(F.Input(underlying))
    }
}
