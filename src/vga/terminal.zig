const VgaEntry = @import("entry.zig").VgaEntry;
const VgaColor = @import("color.zig").VgaColor;

pub const VgaTerminal = struct {
    const Self = @This();

    const WIDTH = 80;
    const HEIGHT = 25;

    var column: u16 = 0;
    var row: u16 = 0;
    pub var entry: VgaEntry = VgaEntry.init(' ', VgaColor.White, VgaColor.Black);
    var buffer: [*]volatile u16 = @ptrFromInt(0xB8000);

    pub fn init() void {
        for (0..Self.HEIGHT) |y| {
            for (0..Self.WIDTH) |x| {
                const index: usize = y * Self.WIDTH + x;
                Self.buffer[index] = @bitCast(Self.entry);
            }
        }
    }

    pub fn put_char(char: u8) void {
        Self.entry.char = char;
        const index: usize = Self.row * Self.WIDTH + Self.column;
        Self.buffer[index] = @bitCast(Self.entry);

        Self.column += 1;
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

    pub fn put(str: []const u8) void {
        for (str) |char| {
            Self.put_char(char);
        }
    }
};
