//! Wrapper around the TSLanguage structure

const api = @import("api/out.zig");
const symbol_api = @import("symbol.zig");

pub const Language = struct {
    language: *const api.TSLanguage,

    fn version(self: Language) u32 {
        return api.ts_language_version(self.language);
    }

    fn symbol_count(self: Language) u32 {
        return api.ts_language_symbol_count(self.language);
    }

    fn symbol_name(self: Language, symbol: symbol_api.Symbol) []const u8 {
        return api.ts_language_symbol_name(self.language, symbol.symbol);
    }

    fn symbol_for_name(self: Language, str: []const u8, is_named: bool) symbol_api.Symbol {
        return symbol_api.Symbol.init(api.ts_language_symbol_for_name(self.language, str, str.len, is_named));
    }
};
