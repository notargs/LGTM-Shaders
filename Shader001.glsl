#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float box(vec2 pos, vec2 rect)
{
	return length(max(vec2(0.0), abs(pos) - rect)) - 0.001;	
}

float lChar(vec2 pos)
{
	return min(box(pos - vec2(-0.06, 0.0), vec2(0.02, 0.1)),
		   box(pos - vec2(0.0, -0.08), vec2(0.08, 0.02)));
}

float gChar(vec2 pos)
{
	return min(min(min(
		box(pos - vec2(-0.06, 0.0), vec2(0.02, 0.1)),
		box(pos - vec2(0.0, -0.08), vec2(0.08, 0.02))),
		box(pos - vec2(0.0, 0.08), vec2(0.08, 0.02))),
		box(pos - vec2(0.06, -0.05), vec2(0.02, 0.05)));
}

float tChar(vec2 pos)
{
	return min(box(pos - vec2(0.0, 0.0), vec2(0.02, 0.1)),
		   box(pos - vec2(0.0, 0.08), vec2(0.08, 0.02)));
}
float mChar(vec2 pos)
{
	return min(min(min(
		box(pos - vec2(-0.06, 0.0), vec2(0.02, 0.1)),
		box(pos - vec2(0.06, 0.0), vec2(0.02, 0.1))),
		box(pos - vec2(0.0, 0.0), vec2(0.02, 0.1))),
		box(pos - vec2(0.0, 0.08), vec2(0.08, 0.02)));
}
float dist(vec2 pos) {
	return min(min(min(
		lChar(pos - vec2(-0.3, 0.0)),
		gChar(pos - vec2(-0.1, 0.0))),
		tChar(pos - vec2(0.1, 0.0))),
		mChar(pos - vec2(0.3, 0.0)));
}

mat2 rot(float a)
{
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, 
		    -s, c);
}

void main( void ) {

	vec2 pos = (gl_FragCoord.xy - resolution.xy / 2.0) / resolution.y;
	pos.x += sin(time * 10.0 + pos.y * 20.0) * 0.01;
	pos *= abs(sin(time)) * 10.0;
	pos /= 1.0 + length(pos) * 0.3;
	pos = mod(pos + vec2(0.45, 0.15), vec2(0.9, 0.3)) - vec2(0.45, 0.15);
	
	vec3 color = vec3(0.0, 0.0, 0.0);
	color += vec3(1.0, 1.0, 1.0) * (0.009 / abs(dist(pos)));
	gl_FragColor = vec4(color, 1.0);

}