const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{ .cpu_arch = .x86 } });
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "hellos",
        .root_source_file = .{ .path = "src/kernel.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.setLinkerScript(.{ .path = "linker.ld" });
    b.installArtifact(exe);

    const run_cmd = b.addSystemCommand(&.{ "qemu-system-i386", "-kernel" });
    run_cmd.addArtifactArg(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run hellOS");
    run_step.dependOn(&run_cmd.step);
}
