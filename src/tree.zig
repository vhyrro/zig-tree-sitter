//! Wrapper around the TSTree structure

const api = @import("api/out.zig");
const Language = @import("language.zig").Language;
const Node = @import("node.zig").Node;

pub const TreeError = error{
    TreeNotFound,
    TreeCopyFailed,
};

// TODO: add missing functions once we make a wrapper for their dependencies
//
//       Missing functions:
//       - `ts_tree_root_node(self: ?*const TSTree) TSNode`
//          Depends on: `TSNode`
//       - `ts_tree_edit(self: ?*TSTree, edit: [*c]const TSInputEdit) void`
//          Depends on: `TSinputEdit`
//       - `ts_tree_get_changed_ranges(old_tree: ?*const TSTree, new_tree: ?*const TSTree, length: [*c]u32) [*c]TSRange`
//          Depends on: `TSRange`
//       - `ts_tree_print_dot_graph(?*const TSTree, [*c]FILE) void`

/// Tree struct, equivalent of `TSTree`
pub const Tree = struct {
    /// `TSTree` struct instance
    tree: *api.TSTree,

    pub fn init(tree: *api.TSTree) Tree {
        return .{
            .tree = tree,
        };
    }

    /// Delete the syntax tree, freeing all of the memory that is used.
    pub fn deinit(self: Tree) void {
        api.ts_tree_delete(self.tree);
    }

    /// Create a shallow copy of the syntax tree.
    ///
    /// You need to copy a syntax tree in order to use it on more than one thread at
    /// a time, as syntax trees are not thread safe.
    pub fn copy(self: Tree) TreeError!Tree {
        return .{
            .tree = api.ts_tree_copy(self.tree) orelse return TreeError.TreeCopyFailed,
        };
    }

    pub fn root(self: Tree) Node {
        return Node.from(api.ts_tree_root_node(self.tree));
    }
};
