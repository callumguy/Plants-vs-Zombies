shader_type canvas_item;

uniform float cooldown : hint_range(0.0, 1.0) = 1.0;          // 0 = ready, 1 = full cooldown
uniform vec4 overlay_color : source_color = vec4(0,0,0,0.6);  // dark overlay color

uniform vec2 uv_start = vec2(0.0, 0.0);  // top-left of atlas region in UV space
uniform vec2 uv_size = vec2(1.0, 1.0);   // size of atlas region in UV space

uniform bool too_expensive = true;

void fragment() {

    if(cooldown!=0.0) {
        // Compute actual center of visible atlas region
        vec2 center = uv_start + 0.5 * uv_size;

        // Vector from center to pixel
        vec2 dir = UV - center;

        // Angle for radial overlay (0 = top, clockwise)
        float angle = atan(dir.y, dir.x);
        angle = (angle + PI/2.0);
        if(angle < 0.0) angle += 2.0 * PI;
        angle = angle / (2.0 * PI);
        angle = 1.0 - angle;

        // Smooth mask for overlay
        // float mask = 1.0 - smoothstep(cooldown, cooldown + edge_smooth, angle);
        float mask = 1.2 - smoothstep(cooldown, cooldown, angle); // mask is 0 or 1
        if(mask<0.5) mask = 0.7;

        // Sample texture
        vec4 tex = texture(TEXTURE, UV);

        // Apply overlay
        vec4 final_color = mix(tex, overlay_color, mask * overlay_color.a);
        final_color.a = tex.a; // preserve original alpha

        COLOR = final_color;
    } else {
        if(too_expensive==false) {
            COLOR = texture(TEXTURE, UV);
        } else {
            vec4 a = mix(texture(TEXTURE, UV), overlay_color, 0.7 * overlay_color.a);
            a.a = texture(TEXTURE, UV).a;
            COLOR = a;
        }
    }
}
