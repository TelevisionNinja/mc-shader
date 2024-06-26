#version 460 compatibility

out vec4 blockColor;
out vec2 lightMapCoordinates;
out vec3 viewSpacePosition;

void main() {
    blockColor = gl_Color;
    lightMapCoordinates = (gl_TextureMatrix[1] * gl_MultiTexCoord2).xy;
    viewSpacePosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = ftransform();
}
