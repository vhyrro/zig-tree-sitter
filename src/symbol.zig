const api = @import("api/out.zig");

pub const SymbolType = enum(c_uint) {
    Regular = 0,
    Anonymous = 1,
    Auxiliary = 2,
};

pub const Symbol = struct {
    symbol: *const api.TSSymbol,
    type: SymbolType,
};
