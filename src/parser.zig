//! Wrapper around the TSParser structure.

const api = @import("api/out.zig");
const language = @import("language.zig").Language;

/// Tree-Sitter Parser errors.
pub const ParserError = error{IncompatibleParserVersion};

/// Parser struct, equivalent of `TSParser` struct.
pub const Parser = struct {
    /// `TSParser` struct instance
    parser: *const api.TSParser,

    /// Create a new parser.
    pub fn init() Parser {
        return api.ts_parser_new();
    }

    /// Instruct the parser to start the next parse from the beginning.
    ///
    /// If the parser previously failed because of a timeout or a cancellation, then
    /// by default, it will resume where it left off on the next call to
    /// `Parser.arse` or other parsing functions. If you don't want to resume,
    /// and instead intend to use this parser to parse some other document, you must
    /// call `Parser.reset` first.
    fn reset(self: Parser) void {
        return api.ts_parser_reset(self.parser);
    }

    /// Delete the parser, freeing all of the memory that is used.
    fn deinit(self: Parser) void {
        return api.ts_parser_delete(self.parser);
    }

    /// Set the language that the parser should use for parsing.
    ///
    /// Returns a `ParserError.IncompatibleParserVersion` error if the language
    /// assignation failed due to a language generated with an incompatible
    /// version of the Tree-Sitter CLI.
    fn set_language(self: Parser, lang: language.language) !void {
        var successful = api.ts_parser_set_language(self.parser, lang);
        if (!successful)
            return ParserError.IncompatibleParserVersion;
    }

    /// Get the parser's current language.
    fn get_language(self: Parser) language.language {
        return api.ts_parser_language(self.parser);
    }
};
