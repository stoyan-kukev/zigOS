const std = @import("std");
const builtin = std.builtin;

const VgaColor = @import("vga/color.zig").VgaColor;
const VgaTerminal = @import("vga/terminal.zig").VgaTerminal;

const MultiBoot = extern struct {
    magic: i32,
    flags: i32,
    checksum: i32,
};

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

export var multiboot align(4) linksection(".multiboot") = MultiBoot{ .magic = MAGIC, .flags = FLAGS, .checksum = -(MAGIC + FLAGS) };

export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

pub export fn _start() callconv(.Naked) noreturn {
    asm volatile (
        \\call *%[main]
        :
        : [_] "{esp}" (&stack_bytes),
          [main] "r" (&kmain),
    );

    while (true) {}
}

pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace, siz: ?usize) noreturn {
    _ = error_return_trace;
    _ = siz;
    _ = msg;
    @setCold(true);
    while (true) {}
}

fn kmain() void {
    VgaTerminal.init();
    var fg = VgaColor.White;
    var bg = VgaColor.Black;
    for (0..30) |_| {
        VgaTerminal.put(" The industrial revolution and it's consequences ");

        fg.next();
        bg.prev();
        VgaTerminal.entry.set_color(fg, bg);
    }
}
