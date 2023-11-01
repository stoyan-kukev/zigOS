const VgaColor = @import("color.zig").VgaColor;

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
