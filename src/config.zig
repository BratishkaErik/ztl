pub const DebugMode = enum {
    none,
    minimal,
    full,
};

const Defaults = struct {
    pub const ztl_debug: DebugMode = .none;
    pub const ztl_max_locals: u16 = 256;
    pub const ztl_max_call_frames: u8 = 255;
    pub const ztl_initial_code_size: u32 = 512;
    pub const ztl_initial_data_size: u32 = 512;
    pub const ztl_deduplicate_string_literals: bool = true;
};

pub fn extract(comptime App: type, comptime field_name: []const u8) @TypeOf(@field(Defaults, field_name)) {
    if (App != void and @hasDecl(App, field_name)) {
        return @field(App, field_name);
    }
    return @field(Defaults, field_name);
}

pub fn shouldDebug(comptime App: type, level: DebugMode) bool {
    const configured_debug_level = extract(App, "ztl_debug");
    return @intFromEnum(configured_debug_level) >= @intFromEnum(level);
}

pub fn LocalType(comptime App: type) type {
    const ml = extract(App, "ztl_max_locals");
    if (ml == 0) @compileError("max_locals must be greater than 0");
    if (ml <= 256) return u8;
    if (ml <= 65536) return u16;
    @compileError("ztl_max_locals must be less than 65536");
}
