shader_type canvas_item;

uniform vec4 shadow_color : hint_color;

uniform float tile_factor = 10.0;
uniform float aspect_ratio = 0.5;

uniform sampler2D texture_offset_uv : hint_black;
uniform vec2 texture_offset_scale = vec2(0.2, 0.2);
uniform float texture_offset_height = 0.1;

uniform float texture_offset_time_scale = 0.05;

uniform float sine_time_scale = 0.44;
uniform vec2 sine_offset_scale = vec2(0.4, 0.4);
uniform float sine_wave_size = 0.01;

uniform vec2 scale = vec2(1.0, 1.0);


vec2 calculate_sine_wave(float time, float multiplier, vec2 uv, vec2 offset_scale) {
	float time_multiplied = time * multiplier;
	float unique_offset = uv.x + uv.y;
	return vec2(
		sin(time_multiplied + unique_offset * offset_scale.x),
		cos(time_multiplied + unique_offset * offset_scale.y)
	);
}


void fragment() {
	vec2 base_uv_offset = UV * texture_offset_scale;
	base_uv_offset += TIME * texture_offset_time_scale;

	vec2 adjusted_uv = UV * tile_factor;
	adjusted_uv.y *= aspect_ratio;
	
	vec2 texture_based_offset = texture(texture_offset_uv, base_uv_offset).rg * 2.0 - 1.0;
	vec2 sine_offset = calculate_sine_wave(TIME, sine_time_scale, adjusted_uv, sine_offset_scale);

	vec2 sine_uv_offset = sine_offset * sine_wave_size;
	vec2 final_waves_uvs = adjusted_uv + texture_based_offset * texture_offset_height + sine_uv_offset;
	float water_height = (sine_offset.y + texture_based_offset.y) * 0.5;
	
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV + sine_uv_offset, 0.0);

	float near_top = (UV.y + sine_uv_offset.y) / (0.2/scale.y);
	near_top = clamp(near_top, 0.0, 1.0);
	near_top = 1.0 - near_top;
	color = mix(color, vec4(1.0), near_top);
	if (near_top > 0.6) {
		color.a = 0.0;
		if (near_top < 0.7) {
			color.a = (0.7 - near_top)/ (0.06 - near_top);
		}
	}

	float alpha = color.a;
	color = mix(textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0), color * 2.0, 0.7);
	color.a = alpha;
	COLOR = color;
}