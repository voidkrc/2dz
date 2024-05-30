const std = @import("std");
const c = @import("c.zig");

pub fn main() !void {
    if (c.glfwInit() == c.GLFW_FALSE) {
        std.debug.print("Failed to initialize cFW\n", .{});
        return;
    }

    const window = c.glfwCreateWindow(640, 480, "Hello World", null, null) orelse {
        c.glfwTerminate();
        return;
    };

    defer {
        c.glfwDestroyWindow(window);
        c.glfwTerminate();
    }

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwMakeContextCurrent(window);

    if (c.gladLoaderLoadGL() == c.GLFW_FALSE) {
        std.debug.print("Failed to initialize cad\n", .{});
        return;
    }

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_CLEAR_VALUE);

        // Draw stuff here

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
}
