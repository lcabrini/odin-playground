#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;

void main() {
    vec2 uv = vec2(fragTexCoord.x, 1.0-fragTexCoord.y) * 2.0 - 1.0;
    uv.x *= renderWidth/renderHeight;

    float d = length(uv);
    d -= 0.5;
    d = abs(d);

    finalColor = vec4(d, d, d, 1.0);
}
