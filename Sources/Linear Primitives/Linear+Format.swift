public import Dimension_Primitives
public import Format_Primitives
import Formatter_Primitives

extension Tagged where Underlying: BinaryFloatingPoint {

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.`Protocol`, F.Input: BinaryFloatingPoint, F.Failure == Never {
        format.format(F.Input(underlying))
    }
}
