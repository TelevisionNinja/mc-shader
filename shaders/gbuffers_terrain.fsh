#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;

layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightMapCoordinates;

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
    vec4 outputColorData = linearColorSpace(texture(gtexture, texCoord));

    // transparency
    float transparency = outputColorData.a;

    if (transparency < 0.5) { // 0.5 boolean
        discard;
    }

    // lighting
    vec3 lightColor = linearColorSpace(texture(lightmap, lightMapCoordinates).rgb);
    vec3 outputColor = outputColorData.rgb * linearColorSpace(foliageColor) * lightColor;

    outColor0 = linearColorSpaceInverse(vec4(outputColor, transparency));
}
