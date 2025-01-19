shader_type canvas_item;
render_mode unshaded; // Credit: LiathTheCrow for original shader code

uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 level2 : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 level3 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 level4 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float num_colors = 7.0;
uniform float luminance_threshold 	: hint_range(0.0,1.0) = .4;
uniform float threshold2 	: hint_range(0.0,1.0) = .52;
uniform float threshold3	: hint_range(0.0,1.0) = .8;
uniform float threshold4	: hint_range(0.0,1.0) = .8;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	float gamma = 0.3;
	float luminance = (0.299*COLOR.r + 0.587*COLOR.g + 0.114*COLOR.b);
	vec3 c = COLOR.rgb;
	c = pow(c, vec3(gamma));
	c = c * num_colors;
	c = floor(c);
	c = c / num_colors;
	c = pow(c, vec3(1.0/gamma));
	
	//vec4 alpha_col = vec4(c.rgb, COLOR.a);
	//COLOR.rgb = c;
	COLOR.rgb = mix(COLOR.rgb, c, step(luminance_threshold, luminance));
	//float rgb_avg = (COLOR.r + COLOR.g + COLOR.b)/3.0;
	//if(luminance < threshold1){
		//COLOR = level1.rgba* luminance;
	//}else if(luminance < threshold2){
		//COLOR = level2.rgba * luminance;
	//}else if(luminance < threshold3){
		//COLOR = level3.rgba * luminance;
	//}else{
		//COLOR = level4.rgba * luminance;
	//}
	//vec4 orig_color = COLOR;
	//COLOR *= luminance;
	
	//COLOR = mix(COLOR, COLOR + level1, step(threshold1, luminance));
	//COLOR = mix(COLOR, COLOR + level2, step(threshold2, luminance));
	//COLOR = mix(COLOR, level3.rgba, step(threshold3, luminance));
	//COLOR = mix(COLOR, level4.rgba, step(threshold4, luminance));
}
