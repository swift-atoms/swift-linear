public import Dimension
public import Format
import Formatter

extension Tagged where Underlying: BinaryFloatingPoint {

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.`Protocol`, F.Input: BinaryFloatingPoint, F.Failure == Never {
        format.format(F.Input(underlying))
    }
}
