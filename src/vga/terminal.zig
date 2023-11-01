const VgaEntry = @import("entry.zig").VgaEntry;
const VgaColor = @import("color.zig").VgaColor;

pub const VgaTerminal = struct {
    const Self = @This();

    pub const WIDTH = 80;
    pub const HEIGHT = 25;

    var column: u16 = 0;
    var row: u16 = 0;
    pub var entry = VgaEntry.init(' ', VgaColor.White, VgaColor.Black);
    var buffer: [*]volatile u16 = @ptrFromInt(0xB8000);

    pub fn init() void {
        for (0..Self.HEIGHT) |y| {
            for (0..Self.WIDTH) |x| {
                const index: usize = y * Self.WIDTH + x;
                Self.buffer[index] = @bitCast(Self.entry);
            }
        }
    }

    pub fn write_char(char: u8) void {
        const index: usize = Self.row * Self.WIDTH + Self.column;

        switch (char) {
            '\n' => {
                Self.column = Self.WIDTH;
            },
            else => {
                Self.entry.char = char;
                Self.buffer[index] = @bitCast(Self.entry);
                Self.column += 1;
            },
        }

        if (Self.column >= Self.WIDTH) {
            Self.column = 0;
            Self.row += 1;

            if (Self.row >= Self.HEIGHT) {
                for (0..Self.HEIGHT) |y| {
                    for (0..Self.WIDTH) |x| {
                        const old: usize = y * Self.WIDTH + x;
                        const new: usize = (y + 1) * Self.WIDTH + x;
                        buffer[old] = buffer[new];
                    }
                }

                Self.row -= 1;
            }
        }
    }

    pub fn write(str: []const u8) void {
        for (str) |char| {
            Self.write_char(char);
        }
    }
};
