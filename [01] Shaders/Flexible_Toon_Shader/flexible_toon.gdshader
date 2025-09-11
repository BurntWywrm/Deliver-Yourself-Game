// Modified Flexible Toon Shader
shader_type spatial;

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform bool use_triplanar = true;
uniform bool clamp_diffuse_to_max = false;



uniform int cuts : hint_range(1, 8) = 3;
uniform float wrap : hint_range(-2.0, 2.0) = 0.0;
uniform float steepness : hint_range(1.0, 8.0) = 1.0;

uniform bool use_attenuation = true;

uniform bool use_specular = false;
uniform float specular_strength : hint_range(0.0, 1.0) = 1.0;
uniform float specular_shininess : hint_range(0.0, 32.0) = 16.0;
uniform sampler2D specular_map : source_color;

uniform bool use_rim = false;
uniform float rim_width : hint_range(0.0, 16.0) = 8.0;
uniform vec4 rim_color : source_color = vec4(1.0);

uniform bool use_ramp = false;
uniform sampler2D ramp : source_color;

uniform bool use_borders = false;
uniform float border_width = 0.01;

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset = vec3(0.0);
uniform float uv1_blend_sharpness : hint_range(0.0, 150.0) = 32.0;

varying vec3 vertex_pos;
varying vec3 normal;
varying vec3 uv1_triplanar_pos;
varying vec3 uv1_power_normal;

float split_specular(float specular) {
	return step(0.5f, specular);
}

void vertex() {
	vertex_pos = VERTEX;
	normal = NORMAL;

	// Triplanar mapping prep
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0); // Invert Y to match Godot convention
}

vec4 triplanar_texture(sampler2D tex, vec3 blend_weights, vec3 pos) {
	vec4 samp = vec4(0.0);
	samp += texture(tex, pos.xy) * blend_weights.z;
	samp += texture(tex, pos.xz) * blend_weights.y;
	samp += texture(tex, pos.zy * vec2(-1.0, 1.0)) * blend_weights.x;
	return samp;
}

void fragment() {
	vec4 tex_color;
	if (use_triplanar) {
		tex_color = triplanar_texture(albedo_texture, uv1_power_normal, uv1_triplanar_pos);
	} else {
		tex_color = texture(albedo_texture, UV);
	}
	ALBEDO = albedo.rgb * tex_color.rgb;
}

void light() {
	// Attenuation
	float attenuation = 1.0;
	if (use_attenuation) {
		attenuation = ATTENUATION;
	}

	// Diffuse lighting
	float NdotL = dot(NORMAL, LIGHT);
	float diffuse_amount = NdotL + (attenuation - 1.0) + wrap;
	diffuse_amount *= steepness;
	float cuts_inv = 1.0 / float(cuts);
	float diffuse_stepped = clamp(diffuse_amount + mod(1.0 - diffuse_amount, cuts_inv), 0.0, 1.0);

	// Borders
	float border = 0.0;
	if (use_borders) {
		float corr_border_width = length(cross(NORMAL, LIGHT)) * border_width * steepness;
		border = step(diffuse_stepped - corr_border_width, diffuse_amount)
			   - step(1.0 - corr_border_width, diffuse_amount);
	}

	// Diffuse result
	vec3 diffuse = ALBEDO.rgb * LIGHT_COLOR / PI;
	if (use_ramp) {
		diffuse *= texture(ramp, vec2(diffuse_stepped * (1.0 - border), 0.0)).rgb;
	} else {
		diffuse *= diffuse_stepped * (1.0 - border);
	}

	if (clamp_diffuse_to_max) {
		DIFFUSE_LIGHT = max(DIFFUSE_LIGHT, diffuse);
	} else {
		DIFFUSE_LIGHT += diffuse;
	}

	// Specular
	if (use_specular) {
		vec3 H = normalize(LIGHT + VIEW);
		float NdotH = dot(NORMAL, H);
		float specular_amount = max(pow(NdotH, specular_shininess * specular_shininess), 0.0)
							  * texture(specular_map, UV).r
							  * attenuation;
		specular_amount = split_specular(specular_amount);
		SPECULAR_LIGHT += specular_strength * specular_amount * LIGHT_COLOR;
	}

	// Rim light
	if (use_rim) {
		float NdotV = dot(NORMAL, VIEW);
		float rim_light = pow(1.0 - NdotV, rim_width);
		SPECULAR_LIGHT += rim_light * rim_color.rgb * rim_color.a * LIGHT_COLOR / PI;
	}
}