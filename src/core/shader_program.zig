const c = @import("../c.zig");

const ShaderProgramError = error{};

pub const ShaderProgram = struct {
    vertex_id: c_uint,
    fragment_id: c_uint,
    program_id: c_uint,

    pub fn init(vertex_file: [*c]const u8, fragment_file: [*c]const u8) ShaderProgramError!ShaderProgram {
        const vertex_shader_instance = c.glCreateShader(c.GL_VERTEX_SHADER);
        const fragment_shader_instance = c.glCreateShader(c.GL_FRAGMENT_SHADER);

        c.glShaderSource(vertex_shader_instance, 1, &vertex_file, null);
        c.glShaderSource(fragment_shader_instance, 1, &fragment_file, null);

        c.glCompileShader(vertex_shader_instance);
        c.glCompileShader(fragment_shader_instance);

        const program = c.glCreateProgram();
        c.glAttachShader(program, vertex_shader_instance);
        c.glAttachShader(program, fragment_shader_instance);
        c.glLinkProgram(program);

        c.glDeleteShader(vertex_shader_instance);
        c.glDeleteShader(fragment_shader_instance);
        return .{ .vertex_id = vertex_shader_instance, .fragment_id = fragment_shader_instance, .program_id = program };
    }

    pub fn deinit(self: ShaderProgram) void {
        c.glDeleteProgram(self.program_id);
    }
};
