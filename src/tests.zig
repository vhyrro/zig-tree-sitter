const lib = @import("lib.zig");

// Make sure the tests within other files also get executed
test {
    _ = lib.Cursor;
    _ = lib.Field;
    _ = lib.Language;
    _ = lib.Node;
    _ = lib.Parser;
    _ = lib.Symbol;
    _ = lib.Tree;
}

const testing = @import("std").testing;

pub extern fn tree_sitter_json() lib.TSLanguage;

pub const example_source =
    \\ {
    \\     "test": [
    \\         2022,
    \\         null
    \\     ]
    \\ }
;

pub fn get_language() lib.Language {
    return lib.Language.from(tree_sitter_json());
}

test "Ensure `tree-sitter-json` is properly linked" {
    try testing.expectEqual(get_language().version(), 13);
}
