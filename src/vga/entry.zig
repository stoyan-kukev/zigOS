const VgaColor = @import("color.zig").VgaColor;

pub const VgaEntry = packed struct {
    char: u8,
    foreground: VgaColor,
    background: VgaColor,

    pub fn init(char: u8, foreground: VgaColor, background: VgaColor) VgaEntry {
        return VgaEntry{ .char = char, .foreground = foreground, .background = background };
    }
};
