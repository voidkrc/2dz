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

    const vertices = [_]c.GLfloat{
        // Positions     // Color
        -0.5, -0.5, 0.0, 0.00, 0.20, 0.60, // Bottom left
        0.5, -0.5, 0.0, 0.40, 0.00, 0.60, // Bottom right
        -0.5, 0.5, 0.0, 0.13, 0.80, 0.00, // Top left
        0.5, 0.5, 0.0, 0.13, 0.80, 0.00, // Top right
    };

    var VBO: c.GLuint = 0;
    var VAO: c.GLuint = 0;
    var IBO: c.GLuint = 0;
    c.glGenVertexArrays(1, &VAO);
    c.glGenBuffers(1, &VBO);
    c.glGenBuffers(1, &IBO);

    // Bind Vertex Array Object
    c.glBindVertexArray(VAO);

    // Copy vertices in buffer for OpenGL
    c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
    c.glBufferData(c.GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, c.GL_STATIC_DRAW);

    // Set vertex attributes pointers
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(c.GLfloat), null);
    c.glEnableVertexAttribArray(0);

    const offset: u8 = @intCast(3 * @sizeOf(c.GLfloat));

    c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(f32), @ptrFromInt(offset));
    c.glEnableVertexAttribArray(1);

    // Use indexes to avoid vertex duplication
    const indeces = [_]c.GLuint{ 2, 0, 1, 3, 2, 1 };
    c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, IBO);
    c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, indeces.len * @sizeOf(c.GLuint), &indeces, c.GL_STATIC_DRAW);

    // Unbind non needed
    c.glBindVertexArray(0);
    c.glClearColor(0.0, 0.10, 0.07, 1.0);

    // Main loop
    while (c.glfwWindowShouldClose(window.window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        // Draw stuff
        c.glUseProgram(shader_program.program_id);
        c.glBindVertexArray(VAO);
        c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, IBO);
        c.glDrawElements(c.GL_TRIANGLES, indeces.len, c.GL_UNSIGNED_INT, null);

        c.glfwSwapBuffers(window.window);
        c.glfwPollEvents();
    }

    c.glDeleteVertexArrays(1, &VAO);
    c.glDeleteBuffers(1, &VBO);
    c.glDeleteBuffers(1, &IBO);
}
