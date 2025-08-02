#version 330

in vec2 fragTexCoord;
in vec4 fragCoord;

out vec4 fragColor;

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
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 3.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));
        vec3 col = palette(length(uv0) + time*0.4);
        d = sin(d*8.0 + time)/8.0;
        d = abs(d);
        d = 0.01 / d;

        finalColor += col * d;
    }
    fragColor = vec4(finalColor, 1.0);
}
