//! Wrapper around the TSTree structure

const api = @import("api/out.zig");
const language = @import("language.zig").Language;

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
    fn copy(self: Tree) Tree {
        return api.ts_tree_copy(self.tree);
    }

    /// Get the language that was used to parse the syntax tree.
    fn get_language(self: Tree) Language.language {
        return api.ts_tree_language(self.tree);
    }
};
