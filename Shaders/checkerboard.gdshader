shader_type canvas_item;

float grid(vec2 p) {
  vec2 orient = normalize(vec2(1.2,1.0));
  vec2 perp = vec2(orient.y, -orient.x);
  float g = mod(floor(1. * dot(p, orient)) + floor(1. * dot(p, perp)), 2.);
  return g;
}

void fragment() {
  vec3 r1 = vec3(.2,.4,.0);
  vec3 r2 = vec3(.1,.3,.0);
  float a = 1.0;
  float time = TIME * 0.2;
  vec2 p = FRAGCOORD.xy / 190.0;
  p = p + vec2(-time, time);
  vec2 iResolution = 1.0/SCREEN_PIXEL_SIZE;
  vec2 q = (FRAGCOORD.xy - (iResolution.xy / 2.)) / iResolution.x / 1.5 ;
  vec4 c = vec4(grid(p));
  
  const vec3 t1 = vec3(1.0, 1.0, 1.0);
  const vec3 t2 = vec3(0.0, 0.0, 0.0); 
  
  const float threshold = 0.1; // Controls target color range
  const float softness = 0.1; // Controls linear falloff
  
  // Get difference to use for falloff if required
  float d1 = distance(c.rgb, t1) - threshold;
  float d2 = distance(c.rgb, t2) - threshold;
  
  // Apply linear falloff if needed, otherwise clamp
  float f1 = clamp(d1 / softness, 0.0, 1.0);
  float f2 = clamp(d2 / softness, 0.0, 1.0);
  
  c = vec4(mix(r1, c.rgb, f1),a);
  COLOR = vec4(mix(r2, c.rgb, f2),a);
}
