const api = @import("api/out.zig");
const Symbol = @import("symbol.zig").Symbol;
const Language = @import("language.zig").Language;

const Node = struct {
    node: *const TSNode,

    fn type(self: Node) []const u8 {
        return api.ts_node_type(self.node);
    }

    fn symbol(self: Node, language: Language) Symbol {
        return Symbol.init(language, api.ts_node_symbol(self.node));
    }

    fn start_byte(self: Node) u32 {
        return api.ts_node_start_byte(self.node);
    }

    // fn start_point() Point {}

    fn end_byte(self: Node) u32 {
        return api.ts_node_end_byte(self.node);
    }

    // fn end_point() Point {}

    fn stringify(self: Node) []const u8 {
        return api.ts_node_string(self.node);
    }

    fn null(self: Node) bool {
        return api.ts_node_is_null(self.node);
    }

    fn named(self: Node) bool {
        return api.ts_node_is_named(self.node);
    }

    fn missing(self: Node) bool {
        return api.ts_node_is_missing(self.node);
    }

    fn extra(self: Node) bool {
        return api.ts_node_is_extra(self.node);
    }

    fn has_changes(self: Node) bool {
        return api.ts_node_has_changes(self.node);
    }

    fn has_error(self: Node) bool {
        return api.ts_node_has_error(self.node);
    }

    fn parent(self: Node) ?Node {
        var parent = api.ts_node_parent(self.node);

        return if (!parent.null()) parent else null;
    }
};
