#version 410 core

in vec3 my_color;
out vec4 FragColor;

void main() {
  FragColor = vec4(my_color, 1.0);
}

