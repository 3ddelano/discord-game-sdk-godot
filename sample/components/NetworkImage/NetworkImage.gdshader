shader_type canvas_item;
uniform float radius:hint_range(0.01,0.99) = 0.5;
const float strength = 0.0005;

void fragment() {
	float dist = distance(vec2(0.5,0.5), UV.xy);
	COLOR = texture(TEXTURE, UV);
	COLOR.a = (COLOR.a - smoothstep(radius - strength, radius + strength, dist));
}