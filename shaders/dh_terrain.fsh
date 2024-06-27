#version 460 compatibility

uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 fogColor;

layout(location = 0) out vec4 outColor0;

in vec4 blockColor;
in vec2 lightMapCoordinates;
in vec3 viewSpacePosition;

vec3 linearColorSpace(in vec3 lighting) {
    return pow(lighting, vec3(2.2));
}

vec4 linearColorSpace(in vec4 lighting) {
    return pow(lighting, vec4(2.2));
}

vec4 linearColorSpaceInverse(in vec4 lighting) {
    return pow(lighting, vec4(1.0 / 2.2));
}

void main() {
    vec4 outputColorData = linearColorSpace(blockColor);

    // transparency
    float transparency = outputColorData.a;

    if (transparency < 0.5) { // 0.5 boolean
        discard;
    }

    // lighting
    vec3 lightColor = linearColorSpace(texture(lightmap, lightMapCoordinates).rgb);
    vec3 outputColor = outputColorData.rgb * lightColor;

    // render distant horizons under normal blocks
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;

    if (depth != 1.0) {
        discard;
    }

    // fog
    vec3 viewSpacePlayerPosition = vec3(0);
    vec3 viewSpaceFragPosition = viewSpacePosition;
    float distanceFromCamera = distance(viewSpacePlayerPosition, viewSpaceFragPosition);
    float maxFogDistance = 8192.0;
    float minFogDistance = 2048.0;
    float fogBlendColor = (distanceFromCamera - minFogDistance) / (maxFogDistance - minFogDistance); // normalize
    fogBlendColor = clamp(fogBlendColor, 0.0, 1.0);
    outputColor = mix(outputColor, fogColor, fogBlendColor);

    outColor0 = linearColorSpaceInverse(vec4(outputColor, transparency));
}
