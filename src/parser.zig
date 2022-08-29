//! Wrapper around the TSParser structure

const api = @import("api/out.zig");
const language = @import("language.zig").Language;

pub const ParserError = error{IncompatibleParserVersion};

pub const Parser = struct {
    parser: *const api.TSParser,

    pub fn new() Parser {
        return api.ts_parser_new();
    }

    fn reset(self: Parser) void {
        return api.ts_parser_reset(self.parser);
    }

    fn delete(self: Parser) void {
        return api.ts_parser_delete(self.parser);
    }

    fn set_language(self: Parser, lang: language) !void {
        var successful = api.ts_parser_set_language(self.parser, lang);
        if (!successful)
            return ParserError.IncompatibleParserVersion;
        return successful;
    }

    fn get_language(self: Parser) language.language {
        return api.ts_parser_language(self.parser);
    }
};
