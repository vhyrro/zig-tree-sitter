const api = @import("api/out.zig");
const language = @import("language.zig");

/// Symbols types enum
pub const SymbolType = enum(c_uint) {
    Regular = 0,
    Anonymous = 1,
    Auxiliary = 2,
};

/// Symbol struct, equivalent of `TSSymbol`
pub const Symbol = struct {
    /// `TSSymbol` struct instance
    symbol: *const api.TSSymbol,
    /// Symbol type
    type: SymbolType,

    /// Initialize a new Symbol
    fn init(lang: language.Language, symbol: *const api.TSSymbol) Symbol {
        return Symbol {
            .symbol = symbol,
            .type = SymbolType(api.ts_language_symbol_type(lang.language, symbol)),
        };
    }
};
