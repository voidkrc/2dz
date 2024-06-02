const std = @import("std");
const c = @import("../c.zig");

const WindowBufferError = error{ WindowInizialization, GLFWInitialization, GLADInitialization, OpenGLVersion };

pub const WindowBuffer = struct {
    width: c_int,
    height: c_int,

    window: *c.GLFWwindow,

    fn loadGL() WindowBufferError!void {
        if (c.gladLoadGL() == 0) {
            return WindowBufferError.GLADInitialization;
        }

        const openGL_version = c.glGetString(c.GL_VERSION);

        if (openGL_version == null) {
            return WindowBufferError.OpenGLVersion;
        }

        std.debug.print("Using OpenGL version {s}\n", .{openGL_version});
    }

    pub fn init(width: c_int, height: c_int) WindowBufferError!WindowBuffer {
        if (c.glfwInit() == c.GLFW_FALSE) {
            return WindowBufferError.GLFWInitialization;
        }

        // Set OpenGL version
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

        const window = c.glfwCreateWindow(width, height, "Z_Engine", null, null) orelse {
            c.glfwTerminate();
            return WindowBufferError.WindowInizialization;
        };

        c.glfwMakeContextCurrent(window);
        c.glfwSwapInterval(0);

        try loadGL();

        return .{ .width = width, .height = height, .window = window };
    }

    pub fn deinit(self: WindowBuffer) void {
        c.glfwTerminate();
        c.glfwDestroyWindow(self.window);
    }
};
