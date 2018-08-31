/// Protocol::StatusFlags
///
/// The status flags are a bit-field.
///
/// https://dev.mysql.com/doc/internals/en/status-flags.html#flag-SERVER_SESSION_STATE_CHANGED
 struct MySQLStatusFlags {
    /// The raw status value.
    var raw: MySQLStatusFlag

    /// Create a new `MySQLStatusFlags` from the raw value.
    init(raw: MySQLStatusFlag) {
        self.raw = raw
    }

    /// Returns true if the capability is enabled.
    func get(_ flag: MySQLStatusFlag) -> Bool {
        return raw & flag > 0
    }

    /// Enables or disables a capability.
    mutating func set(_ capability: MySQLStatusFlag, to enabled: Bool) {
        if enabled {
            raw |= capability
        } else {
            raw &= ~capability
        }
    }
}

extension MySQLStatusFlags: ExpressibleByDictionaryLiteral {
    /// See `ExpressibleByDictionaryLiteral.init(dictionaryLiteral)`
    init(dictionaryLiteral elements: (MySQLStatusFlag, Bool)...) {
        var capabilities = MySQLStatusFlags(raw: 0)
        for (capability, enabled) in elements {
            capabilities.set(capability, to: enabled)
        }
        self = capabilities
    }
}

extension MySQLStatusFlags: ExpressibleByArrayLiteral {
    /// See `ExpressibleByDictionaryLiteral.init(arrayLiteral)`
    init(arrayLiteral elements: MySQLStatusFlag...) {
        var capabilities = MySQLStatusFlags(raw: 0)
        for capability in elements {
            capabilities.set(capability, to: true)
        }
        self = capabilities
    }
}

extension MySQLStatusFlags: CustomStringConvertible {
    var description: String {
        let all: [String: MySQLStatusFlag] = [
            "SERVER_STATUS_IN_TRANS": SERVER_STATUS_IN_TRANS,
            "SERVER_STATUS_AUTOCOMMIT": SERVER_STATUS_AUTOCOMMIT,
            "SERVER_MORE_RESULTS_EXISTS": SERVER_MORE_RESULTS_EXISTS,
            "SERVER_STATUS_NO_GOOD_INDEX_USED": SERVER_STATUS_NO_GOOD_INDEX_USED,
            "SERVER_STATUS_NO_INDEX_USED": SERVER_STATUS_NO_INDEX_USED,
            "SERVER_STATUS_CURSOR_EXISTS": SERVER_STATUS_CURSOR_EXISTS,
            "SERVER_STATUS_LAST_ROW_SENT": SERVER_STATUS_LAST_ROW_SENT,
            "SERVER_STATUS_DB_DROPPED": SERVER_STATUS_DB_DROPPED,
            "SERVER_STATUS_NO_BACKSLASH_ESCAPES": SERVER_STATUS_NO_BACKSLASH_ESCAPES,
            "SERVER_STATUS_METADATA_CHANGED": SERVER_STATUS_METADATA_CHANGED,
            "SERVER_QUERY_WAS_SLOW": SERVER_QUERY_WAS_SLOW,
            "SERVER_PS_OUT_PARAMS": SERVER_PS_OUT_PARAMS,
            "SERVER_STATUS_IN_TRANS_READONLY": SERVER_STATUS_IN_TRANS_READONLY,
            "SERVER_SESSION_STATE_CHANGED": SERVER_SESSION_STATE_CHANGED
        ]
        var desc: [String] = []
        for (name, flag) in all {
            if get(flag) {
                desc.append(name)
            }
        }
        return desc.joined(separator: " | ")
    }
}

typealias MySQLStatusFlag = UInt16

/// a transaction is active
var SERVER_STATUS_IN_TRANS: MySQLStatusFlag = 0x0001

/// auto-commit is enabled
var SERVER_STATUS_AUTOCOMMIT: MySQLStatusFlag = 0x0002

///
var SERVER_MORE_RESULTS_EXISTS: MySQLStatusFlag = 0x0008

///
var SERVER_STATUS_NO_GOOD_INDEX_USED: MySQLStatusFlag = 0x0010

///
var SERVER_STATUS_NO_INDEX_USED: MySQLStatusFlag = 0x0020

/// Used by Binary Protocol Resultset to signal that COM_STMT_FETCH must be used to fetch the row-data.
var SERVER_STATUS_CURSOR_EXISTS: MySQLStatusFlag = 0x0040

///
var SERVER_STATUS_LAST_ROW_SENT: MySQLStatusFlag = 0x0080

///
var SERVER_STATUS_DB_DROPPED: MySQLStatusFlag = 0x0100

///
var SERVER_STATUS_NO_BACKSLASH_ESCAPES: MySQLStatusFlag = 0x0200

///
var SERVER_STATUS_METADATA_CHANGED: MySQLStatusFlag = 0x0400

///
var SERVER_QUERY_WAS_SLOW: MySQLStatusFlag = 0x0800

///
var SERVER_PS_OUT_PARAMS: MySQLStatusFlag = 0x1000

/// in a read-only transaction
var SERVER_STATUS_IN_TRANS_READONLY: MySQLStatusFlag = 0x2000

/// connection state information has changed
var SERVER_SESSION_STATE_CHANGED: MySQLStatusFlag = 0x4000
