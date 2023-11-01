const builtin = @import("std").builtin;

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
    @setCold(true);
    _ = siz;
    _ = error_return_trace;

    VgaTerminal.write(msg);

    while (true) {}
}

fn kmain() void {
    VgaTerminal.init();

    var foreground = VgaColor.Green;
    var background = VgaColor.Black;
    for (0..VgaTerminal.HEIGHT) |_| {
        VgaTerminal.entry.set_color(foreground, background);
        VgaTerminal.write("Welcome to zigOS! Running on Zig version 0.11.0!\n");

        foreground.next();
        background.prev();
    }
}
