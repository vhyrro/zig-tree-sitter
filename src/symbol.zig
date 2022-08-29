const api = @import("api/out.zig");
const language = @import("language.zig");

pub const SymbolType = enum(c_uint) {
    Regular = 0,
    Anonymous = 1,
    Auxiliary = 2,
};

pub const Symbol = struct {
    symbol: *const api.TSSymbol,
    type: SymbolType,

    fn init(lang: language.Language, symbol: *const api.TSSymbol) Symbol {
        return Symbol {
            .symbol = symbol,
            .type = SymbolType(api.ts_language_symbol_type(lang.language, symbol)),
        };
    }
};
