const std = @import("std");
const gl = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub fn main() !void {
    if (gl.glfwInit() == gl.GL_NONE) {
        std.debug.print("Failed to initialize GLFW\n", .{});
        return;
    }

    const window = gl.glfwCreateWindow(640, 480, "Hello World", null, null) orelse {
        gl.glfwTerminate();
        return;
    };

    defer {
        gl.glfwDestroyWindow(window);
        gl.glfwTerminate();
    }

    gl.glfwMakeContextCurrent(window);

    while (gl.glfwWindowShouldClose(window) == gl.GL_NONE) {
        gl.glClear(gl.GL_COLOR_CLEAR_VALUE);

        // Draw stuff here

        gl.glfwSwapBuffers(window);
        gl.glfwPollEvents();
    }
}
