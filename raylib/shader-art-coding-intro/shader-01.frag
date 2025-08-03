#version 330

in vec2 fragCoord;
out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;

void main() {
    vec2 uv = vec2(fragCoord.x, 1.0 - fragCoord.y);
    uv.x *= renderWidth/renderHeight;

    finalColor = vec4(0.0, 0.0, 0.0, 1.0);
}
