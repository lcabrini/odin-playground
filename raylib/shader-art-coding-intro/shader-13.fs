#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;
uniform float time;

void main() {
    vec2 uv = vec2(fragTexCoord.x, 1.0-fragTexCoord.y) * 2.0 - 1.0;
    uv.x *= renderWidth/renderHeight;

    float d = length(uv);
    d = sin(d*8.0 + time)/8.0;
    d = abs(d);
    d = 0.02 / d;

    finalColor = vec4(d, d, d, 1.0);
}
