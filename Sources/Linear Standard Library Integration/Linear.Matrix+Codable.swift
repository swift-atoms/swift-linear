public import Linear

#if !hasFeature(Embedded)
    extension Linear.Matrix: Codable where Rows == 2, Columns == 2, Scalar: Codable {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            self.init(a: a, b: b, c: c, d: d)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(a, forKey: .a)
            try container.encode(b, forKey: .b)
            try container.encode(c, forKey: .c)
            try container.encode(d, forKey: .d)
        }
    }
#endif
