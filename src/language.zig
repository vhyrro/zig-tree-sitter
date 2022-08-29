//! Wrapper around the TSLanguage structure

const api = @import("api/out.zig");

pub const Language = struct {
    language: *const TSLanguage,

    fn version(self: Language) u32 {
        return api.ts_language_version(self.language);
    }
};
