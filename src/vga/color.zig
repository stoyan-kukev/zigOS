pub const VgaColor = enum(u4) {
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
        self.* = @enumFromInt(@intFromEnum(self.*) +% 1);
    }

    pub fn prev(self: *VgaColor) void {
        self.* = @enumFromInt(@intFromEnum(self.*) -% 1);
    }
};
