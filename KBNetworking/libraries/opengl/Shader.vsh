/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Vertex shader that passes attributes through to fragment shader.
 */

attribute vec3 position;
attribute vec2 texCoord;

varying vec2 texCoordVarying;

void main()
{
	
    gl_Position =  vec4(position.x, position.y, position.z, 1.0);
	texCoordVarying = texCoord;
}

