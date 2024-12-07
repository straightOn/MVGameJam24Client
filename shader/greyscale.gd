shader_type canvas_item;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	COLOR = vec4(vec3(gray), texture(TEXTURE, UV).a);
}
