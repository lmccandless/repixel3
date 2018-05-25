 #ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
//uniform vec2 tx;
uniform vec4 target;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
 	vec4 col = texture2D(texture, vertTexCoord.st);
	vec4 highlight = vec4(0.0,1.0,0.0,1.0);
	
	if (col != target){
		//col = highlight;
			 if (texture2D(texture, vertTexCoord.st + vec2(+texOffset.s, 0.0)) == target) col = highlight;
		else if (texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, 0.0)) == target) col = highlight;
		else if (texture2D(texture, vertTexCoord.st + vec2(0.0, -texOffset.t)) == target) col = highlight;
		else if (texture2D(texture, vertTexCoord.st + vec2(0.0, +texOffset.t)) == target) col = highlight;
	}

	//if (col == target) gl_FragColor = vec4(0.0,1.0,0.0,1.0);
	//else gl_FragColor = col;
	gl_FragColor = col;

	//gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}