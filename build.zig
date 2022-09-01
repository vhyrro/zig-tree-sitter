const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("zig-tree-sitter", "src/lib.zig");
    lib.setBuildMode(mode);
    lib.linkLibC();
    lib.install();

    const exe = b.addExecutable("json", "src/main.zig");
    exe.setBuildMode(mode);
    exe.linkLibC();
    exe.addObjectFile("tree-sitter.a");
    exe.addObjectFile("parser.o");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    var main_tests = b.addTest("tests/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
