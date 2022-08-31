//! Wrapper around the TSTree structure

const api = @import("api/out.zig");
const Language = @import("language.zig").Language;

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
    tree: *const api.TSTree,

    /// Delete the syntax tree, freeing all of the memory that is used.
    fn deinit(self: Tree) void {
        api.ts_tree_delete(self.tree);
    }

    /// Create a shallow copy of the syntax tree.
    ///
    /// You need to copy a syntax tree in order to use it on more than one thread at
    /// a time, as syntax trees are not thread safe.
    fn copy(self: Tree) TreeError.TreeCopyFailed!Tree {
        return .{
            .tree = api.ts_tree_copy(self.tree) orelse return TreeError.TreeCopyFailed,
        };
    }

    /// Get the language that was used to parse the syntax tree.
    fn language(self: Tree) TreeError.TreeNotFound!Language {
        return Language{
            .language = api.ts_tree_language(self.tree) orelse return TreeError.TreeNotFound,
        };
    }
};
