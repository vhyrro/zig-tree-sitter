const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-tree-sitter", "src/lib.zig");
    lib.setBuildMode(mode);
    lib.linkLibC();
    lib.addIncludeDir("tree-sitter/lib/src");
    lib.addIncludeDir("tree-sitter/lib/include/");
    lib.addCSourceFile("tree-sitter/lib/src/lib.c", &[_][]const u8 {});
    lib.install();

    var main_tests = b.addTest("src/tests.zig");
    main_tests.use_stage1 = true;
    main_tests.linkLibrary(lib);
    main_tests.addIncludeDir("tree-sitter-json/src/");
    main_tests.addCSourceFile("tree-sitter-json/src/parser.c", &[_][]const u8 {});
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&lib.step);
    test_step.dependOn(&main_tests.step);
}
