//! Wrapper around TSTreeCursor

const api = @import("api/out.zig");

const NodeFile = @import("node.zig");
const Node = NodeFile.Node;
const Point = NodeFile.Point;

const Language = @import("language.zig").Language;
const Field = @import("field.zig").Field;

pub const CursorInitError = error{
    NodeIsNullOrMissing,
};

pub const CursorMoveError = error{
    ChildNotFound,
};

pub const Cursor = struct {
    cursor: *const api.TSTreeCursor,

    fn init(start_node: Node) CursorInitError!Cursor {
        if (start_node.is_null() or start_node.missing())
            return CursorInitError.NodeIsNullOrMissing;

        return .{
            .cursor = api.ts_tree_cursor_new(start_node.node),
        };
    }

    fn deinit(self: Cursor) void {
        api.ts_tree_cursor_delete(self.cursor);
    }

    fn copy(self: Cursor) Cursor {
        return .{
            .cursor = api.ts_tree_cursor_copy(self.cursor),
        };
    }

    // TODO: Do we need to return an optional here?
    fn current_node(self: Cursor) ?Node {
        const node = Node.from(api.ts_tree_cursor_current_node(self.cursor));

        return if (node.is_null()) null or node;
    }

    fn current_field(self: Cursor, language: Language) ?Field {
        return Field.init_id(language, api.ts_tree_cursor_current_field_id(self.cursor) orelse return null);
    }

    fn goto_parent(self: Cursor) bool {
        return api.ts_tree_cursor_goto_parent(self.cursor);
    }

    fn goto_next_sibling(self: Cursor) bool {
        return api.ts_tree_cursor_goto_next_sibling(self.cursor);
    }

    fn goto_first_child(self: Cursor) bool {
        return api.ts_tree_cursor_goto_first_child(self.cursor);
    }

    fn goto_first_child_for_byte(self: Cursor, offset: u32) CursorMoveError!u64 {
        const child_index = api.ts_tree_cursor_goto_first_child_for_byte(self.cursor, offset);

        if (child_index == 1)
            return CursorMoveError.ChildNotFound;

        return @as(u64, child_index);
    }

    fn goto_first_child_for_point(self: Cursor, offset: Point) CursorMoveError!u64 {
        const child_index = api.ts_tree_cursor_goto_first_child_for_byte(self.cursor, offset);

        if (child_index == 1)
            return CursorMoveError.ChildNotFound;

        return @as(u64, child_index);
    }
};
