const api = @import("api/out.zig");
const Symbol = @import("symbol.zig").Symbol;
const Language = @import("language.zig").Language;
const Field = @import("field.zig").Field;

pub const Point = api.TSPoint;

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
        const parent = api.ts_node_parent(self.node);

        return if (!parent.null()) parent else null;
    }

    fn child(self: Node, index: u32) ?Node {
        const child = api.ts_node_child(self.node, index);

        return if (child.null()) null else .{
            .node = child,
        };
    }

    fn child_count(self: Node) u32 {
        return api.ts_node_child_count(self.node);
    }

    fn named_child(self: Node, index: u32) ?Node {
        const named_child = api.ts_node_named_child(self.node, index);

        return if (named_child.null()) null else .{
            .node = named_child,
        };
    }

    fn named_child_count(self: Node) u32 {
        return api.ts_node_named_child_count(self.node);
    }

    fn field_for_child(self: Node, language: Language, index: u32) ?Field {
        return Field.init_name(language, api.ts_node_field_name_for_child(self.node, index) orelse return null);
    }

    fn child_by_field(self: Node, field: Field) ?Node {
        const child = api.ts_node_child_by_field_id(self.node, field.id);

        return if (child.null()) null else .{
            .node = child,
        };
    }

    fn next_sibling(self: Node) ?Node {
        const next_sibling = api.ts_node_next_sibling(self.node);

        return if (next_sibling.null()) null else .{
            .node = next_sibling,
        };
    }

    fn prev_sibling(self: Node) ?Node {
        const prev_sibling = api.ts_node_prev_sibling(self.node);

        return if (prev_sibling.null()) null else .{
            .node = prev_sibling,
        };
    }

    fn next_named_sibling(self: Node) ?Node {
        const next_named_sibling = api.ts_node_next_named_sibling(self.node);

        return if (next_named_sibling.null()) null else .{
            .node = next_named_sibling,
        };
    }

    fn prev_named_sibling(self: Node) ?Node {
        const prev_named_sibling = api.ts_node_prev_named_sibling(self.node);

        return if (prev_named_sibling.null()) null else .{
            .node = prev_named_sibling,
        };
    }

    fn first_child_for_byte(self: Node, index: u32) ?Node {
        const child = api.ts_node_first_child_for_byte(self.node, index);

        return if (child.null()) null else .{
            .node = child,
        };
    }

    fn first_named_child_for_byte(self: Node, index: u32) ?Node {
        const child = api.ts_node_first_named_child_for_byte(self.node, index);

        return if (child.null()) null else .{
            .node = child,
        };
    }

    fn descendant_for_byte_range(self: Node, start: u32, end: u32) ?Node {
        const node = api.ts_node_descendant_for_byte_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    fn descendant_for_point_range(self: Node, start: Point, end: Point) ?Node {
        const node = api.ts_node_descendant_for_point_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    fn named_descendant_for_byte_range(self: Node, start: u32, end: u32) ?Node {
        const node = api.ts_node_named_descendant_for_byte_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    fn named_descendant_for_point_range(self: Node, start: Point, end: Point) ?Node {
        const node = api.ts_node_named_descendant_for_point_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    fn equal(self: Node, other: Node) bool {
        return api.ts_node_eq(self.node, other.node);
    }
};
