const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "z_engine",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Link c library
    exe.addIncludePath(b.path("include"));
    exe.addCSourceFile(.{ .file = b.path("src/third_parties/glad.c") });

    exe.linkSystemLibrary("glfw");
    exe.linkSystemLibrary("GL");

    exe.defineCMacro("GLFW_INCLUDE_NONE", null);

    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
