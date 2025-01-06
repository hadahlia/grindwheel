shader_type canvas_item;

uniform mat3 matrix;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 uv = matrix * vec3(UV - 0.5, 1.0);
	COLOR = texture(TEXTURE, (uv.xy / uv.z) + 0.5);
	COLOR.a *= sign(sign(uv.z) + 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
