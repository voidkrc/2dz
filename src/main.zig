const std = @import("std");
const c = @import("c.zig");
const WindowBuffer = @import("core/window.zig").WindowBuffer;
const ShaderProgram = @import("core/shader_program.zig").ShaderProgram;

pub fn main() !void {
    const window = try WindowBuffer.init(600, 460);
    defer window.deinit();

    // Shaders
    const vertex_content = @embedFile("./core/shaders/default.vert");
    const fragment_content = @embedFile("./core/shaders/default.frag");

    const shader_program = try ShaderProgram.init(vertex_content, fragment_content);
    defer shader_program.deinit();

    const vertices = [_]f32{
        // Positions     // Color
        -0.5, -0.5, 0.0, 0.00, 0.20, 0.60,
        0.5,  -0.5, 0.0, 0.40, 0.00, 0.60,
        0.0,  0.5,  0.0, 0.13, 0.80, 0.00,
    };

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
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(f32), null);
    c.glEnableVertexAttribArray(0);

    const offset: u8 = @intCast(3 * @sizeOf(f32));

    c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(f32), @ptrFromInt(offset));
    c.glEnableVertexAttribArray(1);

    // Unbind non needed
    c.glBindVertexArray(0);
    c.glClearColor(0.0, 0.10, 0.07, 1.0);

    // Main loop
    while (c.glfwWindowShouldClose(window.window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        // Draw stuff
        c.glUseProgram(shader_program.program_id);
        c.glBindVertexArray(VAO);
        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);

        c.glfwSwapBuffers(window.window);
        c.glfwPollEvents();
    }

    c.glDeleteVertexArrays(1, &VAO);
    c.glDeleteBuffers(1, &VBO);
}
