#version 330

in vec2 fragTexCoord;
out vec4 finalColor;

uniform float renderWidth;
uniform float renderHeight;
uniform float time;

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b*cos(6.28318*(c*t*d));
}

void main() {
    vec2 uv = vec2(fragTexCoord.x, 1.0-fragTexCoord.y) * 2.0 - 1.0;
    uv.x *= renderWidth/renderHeight;
    uv = fract(uv * 2.0) - 0.5;

    float d = length(uv);
    vec3 col = palette(d+time);
    d = sin(d*8.0 + time)/8.0;
    d = abs(d);
    d = 0.02 / d;
    col *= d;

    finalColor = vec4(col, 1.0);
}
