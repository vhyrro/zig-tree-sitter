const api = @import("api/out.zig");
const Language = @import("language.zig").Language;

/// Symbols types enum
pub const SymbolType = enum(c_uint) {
    Regular = api.TSSymbolTypeRegular,
    Anonymous = api.TSSymbolTypeAnonymous,
    Auxiliary = api.TSSymbolTypeAuxiliary,
};

/// Symbol struct, equivalent of `TSSymbol`
pub const Symbol = struct {
    /// `TSSymbol` struct instance
    symbol: *const api.TSSymbol,
    /// Symbol type
    type: SymbolType,

    /// Initialize a new Symbol
    fn init(lang: Language, symbol: *const api.TSSymbol) Symbol {
        return Symbol{
            .symbol = symbol,
            .type = SymbolType(api.ts_language_symbol_type(lang.language, symbol)),
        };
    }
};
