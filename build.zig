const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("zig-tree-sitter", "src/lib.zig");
    lib.setBuildMode(mode);
    lib.install();

    const join = std.fs.path.join;

    const libpath = try join(b.allocator, &[_][]const u8{ "tree-sitter", "lib", "src", "lib.c" });

    lib.linkLibC();
    lib.addCSourceFile(libpath, &[_][]const u8{});
    lib.addIncludeDir(try join(b.allocator, &[_][]const u8{ "tree-sitter", "lib", "include" }));
    lib.addIncludeDir(try join(b.allocator, &[_][]const u8{ "tree-sitter", "lib", "src" }));

    var main_tests = b.addTest("tests/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
