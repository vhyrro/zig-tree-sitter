const LanguageFile = @import("language.zig");
const Language = LanguageFile.Language;
const TSLanguage = LanguageFile.TSLanguage;

const Parser = @import("parser.zig").Parser;
const Tree = @import("tree.zig").Tree;

extern fn tree_sitter_json() TSLanguage;

pub fn main() !void {
    const src =
        \\ {
        \\     "hello": "world!"
        \\ }
    ;

    const language = Language.from(tree_sitter_json());

    var parser = try Parser.init(language);
    defer parser.deinit();

    var tree: Tree = try parser.parse_string(src, null);
    defer tree.deinit();

    @import("std").debug.print("{s}", .{tree.root().sexp()});
}
