//! Wrapper around the TSTree structure

const api = @import("api/out.zig");

pub const Tree = struct {
    tree: *const api.TSTree,

    fn copy(self: Tree) Tree {
        return api.ts_tree_copy(self.tree);
    }
};
