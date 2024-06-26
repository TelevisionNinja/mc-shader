#version 460

in vec3 vaPosition;
in vec2 vaUV0; // texture coordinate
in vec4 vaColor; // biome color
in ivec2 vaUV2; // lighting

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

out vec2 texCoord;
out vec3 foliageColor;
out vec2 lightMapCoordinates;

void main() {
    texCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightMapCoordinates = (vaUV2 + 8.0) / 256.0;

    // world curve
    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset, 1)).xyz;
    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition) * 0.01;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset - distanceFromCamera, 1);
}
