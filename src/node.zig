const api = @import("api/out.zig");
const Symbol = @import("symbol.zig").Symbol;
const Language = @import("language.zig").Language;
const Field = @import("field.zig").Field;

pub const Point = api.TSPoint;
pub const InputEdit = api.TSInputEdit;

pub const Node = struct {
    node: *const api.TSNode,

    pub fn from(node: *const api.TSNode) Node {
        return .{
            .node = node,
        };
    }

    pub fn @"type"(self: Node) []const u8 {
        return api.ts_node_type(self.node);
    }

    pub fn symbol(self: Node, language: Language) Symbol {
        return Symbol.init(language, api.ts_node_symbol(self.node));
    }

    pub fn start_byte(self: Node) u32 {
        return api.ts_node_start_byte(self.node);
    }

    // fn start_point() Point {}

    pub fn end_byte(self: Node) u32 {
        return api.ts_node_end_byte(self.node);
    }

    // fn end_point() Point {}

    pub fn content(self: Node) []const u8 {
        return api.ts_node_string(self.node);
    }

    pub fn @"null"(self: Node) bool {
        return api.ts_node_is_null(self.node);
    }

    pub fn named(self: Node) bool {
        return api.ts_node_is_named(self.node);
    }

    pub fn missing(self: Node) bool {
        return api.ts_node_is_missing(self.node);
    }

    pub fn extra(self: Node) bool {
        return api.ts_node_is_extra(self.node);
    }

    pub fn has_changes(self: Node) bool {
        return api.ts_node_has_changes(self.node);
    }

    pub fn has_error(self: Node) bool {
        return api.ts_node_has_error(self.node);
    }

    pub fn parent(self: Node) ?Node {
        const node = api.ts_node_parent(self.node);

        return if (!node.null()) node else null;
    }

    pub fn child(self: Node, index: u32) ?Node {
        const node = api.ts_node_child(self.node, index);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn child_count(self: Node) u32 {
        return api.ts_node_child_count(self.node);
    }

    pub fn named_child(self: Node, index: u32) ?Node {
        const node = api.ts_node_named_child(self.node, index);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn named_child_count(self: Node) u32 {
        return api.ts_node_named_child_count(self.node);
    }

    pub fn field_for_child(self: Node, language: Language, index: u32) ?Field {
        return Field.init_name(language, api.ts_node_field_name_for_child(self.node, index) orelse return null);
    }

    pub fn child_by_field(self: Node, field: Field) ?Node {
        const node = api.ts_node_child_by_field_id(self.node, field.id);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn next_sibling(self: Node) ?Node {
        const node = api.ts_node_next_sibling(self.node);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn prev_sibling(self: Node) ?Node {
        const node = api.ts_node_prev_sibling(self.node);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn next_named_sibling(self: Node) ?Node {
        const node = api.ts_node_next_named_sibling(self.node);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn prev_named_sibling(self: Node) ?Node {
        const node = api.ts_node_prev_named_sibling(self.node);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn first_child_for_byte(self: Node, index: u32) ?Node {
        const node = api.ts_node_first_child_for_byte(self.node, index);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn first_named_child_for_byte(self: Node, index: u32) ?Node {
        const node = api.ts_node_first_named_child_for_byte(self.node, index);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn descendant_for_byte_range(self: Node, start: u32, end: u32) ?Node {
        const node = api.ts_node_descendant_for_byte_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn descendant_for_point_range(self: Node, start: Point, end: Point) ?Node {
        const node = api.ts_node_descendant_for_point_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn named_descendant_for_byte_range(self: Node, start: u32, end: u32) ?Node {
        const node = api.ts_node_named_descendant_for_byte_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn named_descendant_for_point_range(self: Node, start: Point, end: Point) ?Node {
        const node = api.ts_node_named_descendant_for_point_range(self.node, start, end);

        return if (node.null()) null else .{
            .node = node,
        };
    }

    pub fn equal(self: Node, other: Node) bool {
        return api.ts_node_eq(self.node, other.node);
    }

    pub fn edit(self: Node, edits: [*]const InputEdit) void {
        api.ts_node_edit(self.node, edits);
    }
};
