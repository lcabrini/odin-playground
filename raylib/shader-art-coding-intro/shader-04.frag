#version 330

in vec2 fragTexCoord;
out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;

void main() {
    vec2 uv = vec2(fragTexCoord.x, 1.0-fragTexCoord.y);
    uv.x *= renderWidth/renderHeight;

    finalColor = vec4(uv, 0.0, 1.0);
}
