shader_type canvas_item;

uniform bool is_rolled_over = false;
uniform vec4 rollover_color = vec4(vec3(0.6), 1.0);
uniform bool is_pressed = false;
uniform vec4 press_color = vec4(vec3(0.3), 1.0);

void fragment() {
	vec4 roll = is_rolled_over ? rollover_color : vec4(1.0);
	vec4 press = is_pressed ? press_color : vec4(1.0);
	COLOR = texture(TEXTURE, UV) * (roll) * (press);
}
