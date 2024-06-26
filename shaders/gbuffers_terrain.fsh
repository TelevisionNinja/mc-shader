#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;

layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightMapCoordinates;

void main() {
    // lighting
    vec3 lightColor = pow(texture(lightmap, lightMapCoordinates).rgb, vec3(2.2));
    vec4 outputColorData = pow(texture(gtexture, texCoord), vec4(2.2));
    vec3 outputColor = outputColorData.rgb * pow(foliageColor, vec3(2.2)) * lightColor;

    // transparency
    float transparency = outputColorData.a;

    if (transparency < 0.5) { // 0.5 boolean
        discard;
    }

    outColor0 = pow(vec4(outputColor, transparency), vec4(1.0 / 2.2));
}
