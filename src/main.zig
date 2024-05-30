const std = @import("std");
const c = @import("c.zig");

pub fn main() !void {
    if (c.glfwInit() == c.GLFW_FALSE) {
        std.log.err("Failed to initialize GLFW\n", .{});
        return;
    }

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    const window = c.glfwCreateWindow(640, 480, "Z_Engine", null, null) orelse {
        c.glfwTerminate();
        return;
    };

    defer {
        c.glfwDestroyWindow(window);
        c.glfwTerminate();
    }

    c.glfwMakeContextCurrent(window);

    if (c.gladLoadGL() == c.GLFW_FALSE) {
        std.log.err("Failed to initialize glad\n", .{});
        return;
    }

    c.glfwSwapInterval(1);

    // Shaders
    const vertex_shader_source: [*c]const u8 =
        \\#version 330 core
        \\layout (location = 0) in vec4 aPos;
        \\void main()
        \\{
        \\  gl_Position = vec4(aPos);
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
        \\#version 330 core
        \\out vec4 fragment;
        \\void main()
        \\{
        \\  fragment = vec4(1.0, 0.0, 0.0, 1.0);
        \\}
    ;
    const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragment_shader, 1, &fragment_shader_source, null);
    c.glCompileShader(fragment_shader);

    c.glGetShaderiv(fragment_shader, c.GL_COMPILE_STATUS, &success);

    if (success == 0) {
        c.glGetShaderInfoLog(vertex_shader, 512, null, &log[0]);
        std.log.err("Error compiling fragment: {s}\n", .{&log});
    }

    // Shader program
    const program = c.glCreateProgram();
    c.glAttachShader(program, vertex_shader);
    c.glAttachShader(program, fragment_shader);
    c.glLinkProgram(program);

    c.glDeleteShader(vertex_shader);
    c.glDeleteShader(fragment_shader);

    const vertices: [12]f32 = [_]f32{ -0.5, 0.5, 0.0, 0.5, 0.5, 0.0, -0.5, -0.5, 0.0, 0.5, -0.5, 0.0 };

    var VBO: c.GLuint = 0;
    var VAO: c.GLuint = 0;
    c.glGenVertexArrays(1, &VAO);
    c.glGenBuffers(1, &VBO);

    // Bind Vertex Array Object
    c.glBindVertexArray(VAO);

    // Copy vertices in buffer for OpenGL
    c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
    c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, c.GL_STATIC_DRAW);

    // Set vertex attributes pointers
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 3 * @sizeOf(f32), null);
    c.glEnableVertexAttribArray(0);

    c.glClearColor(0.0, 0.0, 1.0, 1.0);
    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        var height: c_int = undefined;
        var width: c_int = undefined;

        c.glfwGetFramebufferSize(window, &width, &height);
        c.glViewport(0, 0, width, height);

        c.glClear(c.GL_COLOR_BUFFER_BIT);

        // Draw stuff
        c.glUseProgram(program);
        c.glBindVertexArray(VAO);
        c.glDrawArrays(c.GL_TRIANGLE_STRIP, 0, 4);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }

    c.glDeleteVertexArrays(1, &VAO);
    c.glDeleteBuffers(1, &VBO);
}
