const lib = @import("lib.zig");

extern fn tree_sitter_json() lib.TSLanguage;

pub fn main() !void {
    const src =
        \\ {
        \\     "hello": "world!"
        \\ }
    ;

    const language = lib.Language.from(tree_sitter_json());

    var parser = try lib.Parser.init(language);
    defer parser.deinit();

    var tree = try parser.parse_string(src, lib.Encoding.UTF8, null);
    defer tree.deinit();

    @import("std").debug.print("{s}", .{tree.root().sexp()});
}
