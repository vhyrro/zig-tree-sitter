const std = @import("std");
const api = @import("api/out.zig");
const Language = @import("language.zig").Language;
const Parser = @import("parser.zig").Parser;

pub extern fn tree_sitter_json() *api.TSLanguage;

pub fn main() !void {
    const l = tree_sitter_json();
    _ = api.ts_language_version(l);
}
