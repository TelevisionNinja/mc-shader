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

void main() {
    // lighting
    vec3 lightColor = texture(lightmap, lightMapCoordinates).rgb;
    vec4 outputColorData = blockColor;
    vec3 outputColor = outputColorData.rgb * lightColor;

    // transparency
    float transparency = outputColorData.a;

    if (transparency < 0.5) { // 0.5 boolean
        discard;
    }

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
    float maxFogDistance = 4096.0;
    float minFogDistance = 512.0;
    float fogBlendColor = (distanceFromCamera - minFogDistance) / (maxFogDistance - minFogDistance); // normalize
    fogBlendColor = clamp(fogBlendColor, 0.0, 1.0);
    outputColor = mix(outputColor, fogColor, fogBlendColor);

    outColor0 = vec4(outputColor, transparency);
}
