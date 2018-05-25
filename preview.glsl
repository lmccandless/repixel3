 #ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
//uniform vec2 tx;
uniform vec4 target;
uniform vec4 replacement;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
 	vec4 col = texture2D(texture, vertTexCoord.st);
	if (col == target){
		col = replacement;
	}
	gl_FragColor = col;
}