// FlutterError does not automatically conform to Swift's Error protocol.
// This retroactive conformance is required for use with Result<T, FlutterError>.
extension FlutterError: @retroactive Error {}
