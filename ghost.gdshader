shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float ghost_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float brightness : hint_range(1.0, 2.0) = 1.5;
uniform vec3 ghost_color : source_color = vec3(0.7, 0.9, 1.0); // Light blue-green tint

void fragment() {
    vec2 ghost_offset = vec2(0.01, 0.01);
    vec4 original = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 ghost = texture(SCREEN_TEXTURE, SCREEN_UV + ghost_offset);
    
    // Blend original and ghost images
    vec4 blended = mix(original, ghost, ghost_intensity);
    
    // Increase brightness and reduce color saturation
    vec3 bright_color = blended.rgb * brightness;
    float luminance = dot(bright_color, vec3(0.299, 0.587, 0.114));
    vec3 desaturated = mix(vec3(luminance), bright_color, 0.5);
    
    // Apply ghost color tint
    vec3 tinted = mix(desaturated, ghost_color, 0.3);
    
    COLOR = vec4(tinted, 1.0 - ghost_intensity * 0.5);
}