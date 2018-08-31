/// MySQL specific `SQLDefaultLiteral`.
public struct MySQLDefaultLiteral: SQLDefaultLiteral {
    /// See `SQLDefaultLiteral`.
    public static var `default`: MySQLDefaultLiteral {
        return .init()
    }
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable], aliases: SQLTableAliases?) -> String {
        return "DEFAULT"
    }
}
