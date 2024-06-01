const std = @import("std");
const c = @import("c.zig");
const windowBuffer = @import("core/window.zig").WindowBuffer;

pub fn main() !void {
    const window = try windowBuffer.init(600, 460);
    defer window.deinit();

    // Shaders
    const vertex_shader_source: [*c]const u8 =
        \\#version 410 core
        \\layout (location = 0) in vec3 aPos;
        \\void main()
        \\{
        \\  gl_Position = gl_Position = vec4(aPos, 1.0);
        \\}
    ;

    const vertex_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
    c.glShaderSource(vertex_shader, 1, &vertex_shader_source, null);
    c.glCompileShader(vertex_shader);

    var success: c.GLint = 0;
    var log: [512]u8 = undefined;

    c.glGetShaderiv(vertex_shader, c.GL_COMPILE_STATUS, &success);

    if (success == 0) {
        c.glGetShaderInfoLog(vertex_shader, 512, null, &log[0]);
        std.log.err("Error compiling vertext: {s}\n", .{&log});
    }

    const fragment_shader_source: [*c]const u8 =
        \\#version 410 core
        \\out vec4 fragment;
        \\void main()
        \\{
        \\  fragment = vec4(1.0, 1.0, 1.0, 1.0);
        \\}
    ;
    const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragment_shader, 1, &fragment_shader_source, null);
    c.glCompileShader(fragment_shader);

    c.glGetShaderiv(fragment_shader, c.GL_COMPILE_STATUS, &success);

    if (success == 0) {
        c.glGetShaderInfoLog(fragment_shader, 512, null, &log[0]);
        std.log.err("Error compiling fragment: {s}\n", .{&log});
    }

    // Shader program
    const program = c.glCreateProgram();
    c.glAttachShader(program, vertex_shader);
    c.glAttachShader(program, fragment_shader);
    c.glLinkProgram(program);
    defer c.glDeleteProgram(program);

    c.glDeleteShader(vertex_shader);
    c.glDeleteShader(fragment_shader);

    const vertices = [_]f32{ -0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0 };

    var VBO: c.GLuint = 0;
    var VAO: c.GLuint = 0;
    c.glGenVertexArrays(1, &VAO);
    c.glGenBuffers(1, &VBO);

    // Bind Vertex Array Object
    c.glBindVertexArray(VAO);

    // Copy vertices in buffer for OpenGL
    c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
    c.glBufferData(c.GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, c.GL_STATIC_DRAW);

    // Set vertex attributes pointers
    c.glEnableVertexAttribArray(0);
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 0, null);

    // Unbind non needed
    c.glBindVertexArray(0);
    c.glDisableVertexAttribArray(0);

    c.glClearColor(0.0, 0.10, 0.07, 1.0);

    while (c.glfwWindowShouldClose(window.window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        // Draw stuff
        c.glUseProgram(program);
        c.glBindVertexArray(VAO);
        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);

        c.glfwSwapBuffers(window.window);
        c.glfwPollEvents();
    }

    c.glDeleteVertexArrays(1, &VAO);
    c.glDeleteBuffers(1, &VBO);
}
