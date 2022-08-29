//! Wrapper around the TSTree structure

const api = @import("api/out.zig");

/// Tree struct, equivalent of `TSTree`
pub const Tree = struct {
    /// `TSTree` struct instance
    tree: *const api.TSTree,

    /// Create a shallow copy of the syntax tree.
    ///
    /// You need to copy a syntax tree in order to use it on more than one thread at
    /// a time, as syntax trees are not thread safe.
    fn copy(self: Tree) Tree {
        return api.ts_tree_copy(self.tree);
    }
};
