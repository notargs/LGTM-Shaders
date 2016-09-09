#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

#define PI 3.1415926535

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec3 co)
{
	return fract(sin(dot(co.xyz, vec3(12.9898, 78.233, 56.787))) * 43758.5453);
}

float noise(vec3 pos)
{
	vec3 ip = floor(pos);
	vec3 fp = smoothstep(0.0, 1.0, fract(pos));
	vec4 a = vec4(
		rand(ip + vec3(0, 0, 0)),
		rand(ip + vec3(1, 0, 0)),
		rand(ip + vec3(0, 1, 0)),
		rand(ip + vec3(1, 1, 0)));
	vec4 b = vec4(
		rand(ip + vec3(0, 0, 1)),
		rand(ip + vec3(1, 0, 1)),
		rand(ip + vec3(0, 1, 1)),
		rand(ip + vec3(1, 1, 1)));
 
	a = mix(a, b, fp.z);
	a.xy = mix(a.xy, a.zw, fp.y);
	return mix(a.x, a.y, fp.x);
}


float perlin(vec3 pos)
{
	return (noise(pos) * 32.0 +
		noise(pos * 2.0 ) * 16.0 +
		noise(pos * 4.0) * 8.0 +
		noise(pos * 8.0) * 4.0 +
		noise(pos * 16.0) * 2.0 +
		noise(pos * 32.0) * 1.0) / 64.0;
}

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
		mChar(pos - vec2(0.3, 0.0)))
		+ (length(fract(pos * 40.0 + time) - 0.5) - 0.5) / (sin(time * 3.0 + (pos.x + pos.y) * 2.0) * 14.0 + 16.0);
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
	
	vec3 color = vec3(0.0, 0.0, 0.0);
	if (dist(pos) < 0.001) color += vec3(1.0, 1.0, 0.0);
	
	if (fract(pos.x * 10.0 + time) < 0.1) color += vec3(0.0, 0.3, 0.0);
	if (fract(pos.y * 10.0 + time) < 0.1) color += vec3(0.0, 0.3, 0.0);
	//color += 0.01 / abs(perlin(vec3(pos * 10.0 + time, time * 1.0)) - 0.5) * vec3(0.0, 0.3, 0.0);
	gl_FragColor = vec4(color, 1.0);

}