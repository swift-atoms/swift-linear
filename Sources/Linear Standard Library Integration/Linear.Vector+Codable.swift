public import Linear

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
