const std = @import("std");
const gl = @cImport({
    @cInclude("GLFW/glfw3.h");
});

usingnamespace gl;

pub fn main() !void {
    if (gl.glfwInit() == 0) {
        std.debug.print("Failed to initialize GLFW\n", .{});
        return;
    }

    const window = gl.glfwCreateWindow(640, 480, "Hello World", null, null);
    if (window == null) {
        gl.glfwTerminate();
        return;
    }

    gl.glfwMakeContextCurrent(window);

    while (gl.glfwWindowShouldClose(window) == 0) {
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);

        // Draw stuff here

        gl.glfwSwapBuffers(window);
        gl.glfwPollEvents();
    }

    gl.glfwDestroyWindow(window);
    gl.glfwTerminate();
}
