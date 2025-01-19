shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, depth_prepass_alpha;

uniform bool active = false;
uniform vec3 flash_col: source_color = vec3(1.,0.,0.);
uniform float intensity : hint_range(0, 1) = 1.0;
uniform sampler2D tex: source_color;

void fragment() {
	//vec4 col = texture(, UV);
	//vec4 set_col = col;
	//if(active == true) {
		//set_col = flash_col;
	//}
	//ALBEDO *= set_col.rgb;
	vec4 col = texture(tex, UV);
	ALBEDO *= mix(col.rgb, flash_col, intensity);
	//ALPHA = col.a;
}
