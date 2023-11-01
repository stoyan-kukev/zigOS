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
