const lib = @import("lib.zig");

const testing = @import("std").testing;

extern fn tree_sitter_json() lib.TSLanguage;

test "Ensure `tree-sitter-json` is properly linked" {
    const Language = lib.Language;

    var language = Language.from(tree_sitter_json());
    try testing.expectEqual(language.version(), 13);
}
