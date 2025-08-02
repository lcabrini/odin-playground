#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;

void main() {
    vec2 uv = fragTexCoord;
    uv.x *= renderWidth/renderHeight;

    finalColor = vec4(uv.x, 0.0, 0.0, 1.0);
}
