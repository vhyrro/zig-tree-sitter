//! Wrapper around the TSParser structure.

const api = @import("api/out.zig");
const Language = @import("language.zig").Language;
const Tree = @import("tree.zig").Tree;

/// Tree-Sitter Parser errors.
pub const ParserError = error{ ParserInitializationFailure, IncompatibleParserVersion };
pub const ParseFailure = error{
    Cancelled,
};

pub const Encoding = enum(u32) {
    UTF8 = api.TSInputEncodingUTF8,
    UTF16 = api.TSInputEncodingUTF16,
};

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

    test "Parser initialization & deinitialization" {
        const tests = @import("tests.zig");

        const parser = try Parser.init(tests.get_language());
        defer parser.deinit();
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
        return self.language;
    }

    test "Parser.get_language()" {
        const testing = @import("std").testing;

        const language = @import("tests.zig").get_language();

        const parser = try Parser.init(language);
        defer parser.deinit();

        // Ensure both structures hold a pointer to the same TSLanguage struct
        try testing.expectEqual(parser.get_language().language, language.language);
    }

    pub fn parse_string(self: Parser, input: []const u8, encoding: Encoding, old_tree: ?Tree) ParseFailure!Tree {
        const old_tree_ptr = if (old_tree) |_| old_tree.?.tree else null;
        return Tree.init(api.ts_parser_parse_string_encoding(self.parser, old_tree_ptr, input.ptr, @truncate(u32, input.len), @enumToInt(encoding)) orelse return ParseFailure.Cancelled);
    }

    test "Parsing strings" {
        const tests = @import("tests.zig");
        const language = tests.get_language();
        const source = tests.example_source;

        const parser = try Parser.init(language);
        defer parser.deinit();

        // Just check to see if the parsing process completes successfully
        _ = try parser.parse_string(source, Encoding.UTF8, null);
    }
};
