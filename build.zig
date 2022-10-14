const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const root = comptime std.fs.path.dirname(@src().file) orelse ".";
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-tree-sitter", root ++ "/src/lib.zig");
    lib.use_stage1 = true;
    lib.setBuildMode(mode);
    linkTreeSitter(lib);
    lib.install();

    var main_tests = b.addTest(root ++ "/src/tests.zig");
    main_tests.use_stage1 = true;
    main_tests.linkLibrary(lib);
    main_tests.addIncludeDir(root ++ "/tree-sitter-json/src");
    main_tests.addCSourceFile(root ++ "/tree-sitter-json/src/parser.c", &[_][]const u8 {});
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&lib.step);
    test_step.dependOn(&main_tests.step);
}

pub fn linkTreeSitter(exe: *std.build.LibExeObjStep) void {
    const root = comptime std.fs.path.dirname(@src().file) orelse ".";

    exe.linkLibC();
    exe.addIncludeDir(root ++ "/tree-sitter/lib/src");
    exe.addIncludeDir(root ++ "/tree-sitter/lib/include");
    exe.addCSourceFile(root ++ "/tree-sitter/lib/src/lib.c", &[_][]const u8 {});
}
