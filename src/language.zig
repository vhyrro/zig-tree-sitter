//! Wrapper around the TSLanguage structure

const api = @import("api/out.zig");
const symbol = @import("symbol.zig");

pub const Language = struct {
    language: *const api.TSLanguage,

    fn version(self: Language) u32 {
        return api.ts_language_version(self.language);
    }

    fn symbol_count(self: Language) u32 {
        return api.ts_language_symbol_count(self.language);
    }
};
