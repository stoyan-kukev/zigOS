const assert = @import("std").debug.assert;

pub const GDT = extern struct {
    pub const Entry = packed struct(u64) {
        limit_low: u16,
        base_low: u16,
        base_mid: u8,
        access_byte: packed struct {
            accessed: bool,
            read_write: bool,
            direction_conforming: bool,
            executable: bool,
            code_data_segment: bool,
            dpl: u2,
            present: bool,
        },
        limit_high: u4,
        reserved: u1 = 0,
        long_mode: bool,
        size_flag: bool,
        granularity: bool,
        base_high: u8,

        comptime {
            assert(@bitSizeOf(@This()) == 64);
        }
    };

    pub const Descriptor = packed struct {
        limit: u16,
        base: u32,

        comptime {
            assert(@bitSizeOf(@This()) == 48);
        }
    };

    pub const null_entry = GDT.Entry{
        .limit_low = 0,
        .base_low = 0,
        .base_mid = 0,
        .access_byte = .{
            .accessed = false,
            .read_write = false,
            .direction_conforming = false,
            .executable = false,
            .code_data_segment = false,
            .dpl = 0,
            .present = false,
        },
        .limit_high = 0,
        .long_mode = false,
        .size_flag = false,
        .granularity = false,
        .base_high = 0,
    };

    pub const kernel_code = GDT.Entry{
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_mid = 0,
        .access_byte = .{
            .accessed = false,
            .read_write = true,
            .direction_conforming = false,
            .executable = true,
            .code_data_segment = true,
            .dpl = 0,
            .present = true,
        },
        .limit_high = 0xF,
        .long_mode = false,
        .size_flag = true,
        .granularity = true,
        .base_high = 0,
    };

    pub const kernel_data = GDT.Entry{
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_mid = 0,
        .access_byte = .{
            .accessed = false,
            .read_write = true,
            .direction_conforming = false,
            .executable = false,
            .code_data_segment = true,
            .dpl = 0,
            .present = true,
        },
        .limit_high = 0xF,
        .long_mode = false,
        .size_flag = true,
        .granularity = true,
        .base_high = 0,
    };

    pub const user_code = GDT.Entry{
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_mid = 0,
        .access_byte = .{
            .accessed = false,
            .read_write = true,
            .direction_conforming = false,
            .executable = true,
            .code_data_segment = true,
            .dpl = 3,
            .present = true,
        },
        .limit_high = 0xF,
        .long_mode = false,
        .size_flag = true,
        .granularity = true,
        .base_high = 0,
    };

    pub const user_data = GDT.Entry{
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_mid = 0,
        .access_byte = .{
            .accessed = false,
            .read_write = true,
            .direction_conforming = false,
            .executable = false,
            .code_data_segment = true,
            .dpl = 3,
            .present = true,
        },
        .limit_high = 0xF,
        .long_mode = false,
        .size_flag = true,
        .granularity = true,
        .base_high = 0,
    };
};
