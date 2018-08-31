import Bits

extension MySQLPacket {
    /// 14.1.3.1 OK_Packet
    ///
    /// An OK packet is sent from the server to the client to signal successful completion of a command.
    /// As of MySQL 5.7.5, OK packes are also used to indicate EOF, and EOF packets are deprecated.
    ///
    /// If CLIENT_PROTOCOL_41 is set, the packet contains a warning count.
    struct OK {
        /// int<lenenc>    affected_rows    affected rows
        var affectedRows: UInt64

        /// int<lenenc>    last_insert_id    last insert-id
        var lastInsertID: UInt64?

        /// int<2>    status_flags    Status Flags
        var statusFlags: MySQLStatusFlags

        ///  int<2>    warnings    number of warnings
        var warningsCount: UInt16?

        ///  string<lenenc>    info    human readable status information
        var info: String

        /// string<lenenc>    session_state_changes    session state info
        var sessionStateChanges: String?

        /// Parses a `MySQLOKPacket` from the `ByteBuffer`.
        init(bytes: inout ByteBuffer, capabilities: MySQLCapabilities, length: Int) throws {
            let startIndex = bytes.readerIndex

            let header = try bytes.requireInteger(endianness: .little, as: Byte.self)
            switch header {
            case 0x00, 0xFE: break
            default: throw MySQLError(identifier: "okPacketHeader", reason: "Invalid OK packet header: \(header)")
            }

            affectedRows = try bytes.requireLengthEncodedInteger()
            lastInsertID = try bytes.requireLengthEncodedInteger()
            
            if capabilities.contains(.CLIENT_PROTOCOL_41) {
                statusFlags = try .init(raw: bytes.requireInteger(endianness: .little))
                warningsCount = try bytes.requireInteger(endianness: .little)
            } else if capabilities.contains(.CLIENT_TRANSACTIONS) {
                statusFlags = try .init(raw: bytes.requireInteger(endianness: .little))
            } else {
                statusFlags = []
            }

            if capabilities.contains(.CLIENT_SESSION_TRACK) {
                if bytes.readerIndex - startIndex >= length {
                    // entire packet has been read already
                    info = ""
                } else {
                    info = try bytes.requireLengthEncodedString()
                    if statusFlags.get(SERVER_SESSION_STATE_CHANGED) {
                        sessionStateChanges = try bytes.requireLengthEncodedString()
                    }
                }
            } else {
                /// FIXME: need to know packet length here?
                info = try bytes.requireString(length: length - (bytes.readerIndex - startIndex))
            }
        }
    }
}
