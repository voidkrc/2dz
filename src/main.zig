const std = @import("std");
const gl = @cImport({
    @cInclude("glad/gl.h");
    @cInclude("glfw3.h");
});

pub fn main() !void {
    if (gl.glfwInit() == gl.GLFW_FALSE) {
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

    gl.glfwWindowHint(gl.GLFW_CONTEXT_VERSION_MAJOR, 3);
    gl.glfwWindowHint(gl.GLFW_CONTEXT_VERSION_MINOR, 3);
    gl.glfwWindowHint(gl.GLFW_OPENGL_PROFILE, gl.GLFW_OPENGL_CORE_PROFILE);
    gl.glfwMakeContextCurrent(window);

    if (gl.gladLoaderLoadGL() == gl.GLFW_FALSE) {
        std.debug.print("Failed to initialize Glad\n", .{});
        return;
    }

    while (gl.glfwWindowShouldClose(window) == gl.GLFW_FALSE) {
        gl.glClear(gl.GL_COLOR_CLEAR_VALUE);

        // Draw stuff here

        gl.glfwSwapBuffers(window);
        gl.glfwPollEvents();
    }
}
