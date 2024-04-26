#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec3 normal;

varying vec3 fragNormal;

void main() {
    // Transform vertex position
    gl_Position = projectionMatrix * modelViewMatrix * position;

    // Transform normal (in world space)
    fragNormal = normalize(normalMatrix * normal);
}