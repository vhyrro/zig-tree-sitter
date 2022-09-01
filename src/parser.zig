//! Wrapper around the TSParser structure.

const api = @import("api/out.zig");
const Language = @import("language.zig").Language;
const Tree = @import("tree.zig").Tree;

/// Tree-Sitter Parser errors.
pub const ParserError = error{ ParserInitializationFailure, IncompatibleParserVersion, ParseFailure };

/// Parser struct, equivalent of `TSParser` struct.
pub const Parser = struct {
    /// `TSParser` struct instance
    parser: *api.TSParser,

    /// An internal reference to a language. Unlike regular treesitter APIs,
    /// Zig TS bindings require that a Parser be bound to a language to minimize
    /// the amount of error checking required.
    language: Language,

    /// Create a new parser.
    pub fn init(language: Language) ParserError!Parser {
        var parser: Parser = .{
            .parser = api.ts_parser_new() orelse return ParserError.ParserInitializationFailure,
            .language = language,
        };

        if (api.ts_parser_set_language(parser.parser, language.language))
            return parser
        else {
            parser.deinit();
            return ParserError.IncompatibleParserVersion;
        }
    }

    /// Instruct the parser to start the next parse from the beginning.
    ///
    /// If the parser previously failed because of a timeout or a cancellation, then
    /// by default, it will resume where it left off on the next call to
    /// `Parser.parse` or other parsing functions. If you don't want to resume,
    /// and instead intend to use this parser to parse some other document, you must
    /// call `Parser.reset` first.
    pub fn reset(self: Parser) void {
        return api.ts_parser_reset(self.parser);
    }

    /// Delete the parser, freeing all of the memory that is used.
    pub fn deinit(self: Parser) void {
        return api.ts_parser_delete(self.parser);
    }

    /// Get the parser's current language.
    pub fn get_language(self: Parser) Language {
        // Thanks to the fact that there always must be a language
        // attached to a parser we can safely use .? here.
        return Language.from(api.ts_parser_language(self.parser).?);
    }

    pub fn parse_string(self: Parser, content: []const u8, old_tree: ?Tree) ParserError!Tree {
        var old_tree_ptr = if (old_tree) |_| old_tree.?.tree else null;
        return Tree.init(api.ts_parser_parse_string(self.parser, old_tree_ptr, content.ptr, @truncate(u32, content.len)) orelse return ParserError.ParseFailure);
    }
};
