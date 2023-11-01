pub const VgaColor = enum(u8) {
    Black,
    Blue,
    Green,
    Cyan,
    Red,
    Magenta,
    Brown,
    LightGrey,
    DarkGrey,
    LightBlue,
    LightGreen,
    LightCyan,
    LightRed,
    LightMagenta,
    LightBrown,
    White,

    pub fn next(self: *VgaColor) void {
        if (self.* == VgaColor.White) {
            self.* = VgaColor.Black;
        }
        self.* = @enumFromInt(@intFromEnum(self.*) + 1);
    }

    pub fn prev(self: *VgaColor) void {
        if (self.* == VgaColor.Black) {
            self.* = VgaColor.White;
        }
        self.* = @enumFromInt(@intFromEnum(self.*) - 1);
    }
};

pub const VgaEntry = packed struct {
    char: u8,
    color: u8,

    pub fn init(char: u8, fg: VgaColor, bg: VgaColor) VgaEntry {
        var temp = VgaEntry{ .char = char, .color = 0 };
        temp.set_color(fg, bg);
        return temp;
    }

    pub fn set_color(self: *VgaEntry, fg: VgaColor, bg: VgaColor) void {
        self.color = @intFromEnum(fg) | @intFromEnum(bg) << 4;
    }
};

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
