
## Layer and ownership

Linear combines mathematical values with spatial tags, named geometric roles and angle operations. It is a molecule. Vector and Matrix now own independent mathematical cores; adapting this implementation is deferred to the higher-layer pass.

Circular angle operations require only `Trigonometry.Circular`. Linear no longer
depends on or reexports the broad Numeric package or its numeric-shims dependency.
Matrix rotation uses the same generic capability instead of separate Double/Float
implementations. Concrete transcendental implementations belong at higher layers;
the tests supply their own implementation without adding a production dependency.

The legacy Vector/Matrix storage and Spatial role types still require migration to
their atom owners. Passing the current tests does not settle this package's final
responsibility or justify retaining the legacy representations.

Vector and Matrix storage now delegate to the current mathematical atoms while
legacy wrappers retain frame identity for consumers being migrated. Vector coding
also delegates to the atom and enforces exact dimension, including dimension zero.
Matrix retains its existing 2x2 keyed wire format. Transposition and multiplication
use Matrix; mapping visits each scalar exactly once, including empty shapes.
These changes remove duplicate storage implementations without claiming the
remaining Spatial role and numeric interpretation APIs are final owners.
