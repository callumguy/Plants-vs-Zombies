# ai code btw

## emitter_loader.gd
## Parses a custom Emitter XML file and applies settings to a CPUParticles2D node.
##
## Usage:
##   var loader = EmitterLoader.new()
##   loader.load_emitter("res://effects/dirt.xml", $CPUParticles2D)
 
class_name EmitterLoader
extends RefCounted
 
 
# ── Public entry point ────────────────────────────────────────────────────────
 
func load_emitter(path: String, particles: CPUParticles2D) -> bool:
    var xml := XMLParser.new()
    if xml.open(path) != OK:
        push_error("EmitterLoader: cannot open '%s'" % path)
        return false
 
    var data := _parse_xml(xml)
    _apply(data, particles)
    return true
 
 
# ── XML parsing ───────────────────────────────────────────────────────────────
 
func _parse_xml(xml: XMLParser) -> Dictionary:
    var data := {}
    var current_field: Dictionary = {}
    var inside_field := false
    var current_tag := ""
 
    while xml.read() == OK:
        match xml.get_node_type():
 
            XMLParser.NODE_ELEMENT:
                current_tag = xml.get_node_name()
                if current_tag == "Field":
                    current_field = {}
                    inside_field = true
 
            XMLParser.NODE_ELEMENT_END:
                if xml.get_node_name() == "Field" and inside_field:
                    # Store fields as a list so multiple fields are supported
                    if not data.has("Fields"):
                        data["Fields"] = []
                    data["Fields"].append(current_field)
                    inside_field = false
                    current_field = {}
 
            XMLParser.NODE_TEXT:
                var raw := xml.get_node_data().strip_edges()
                if raw == "" or current_tag == "":
                    continue
                if inside_field:
                    current_field[current_tag] = raw
                else:
                    data[current_tag] = raw
 
    return data
 
 
# ── Value helpers ─────────────────────────────────────────────────────────────
 
## Parse "[min max]" → returns [min, max] as floats. Falls back to [v, v].
func _parse_range(token: String) -> Array:
    token = token.strip_edges()
    if token.begins_with("[") and token.ends_with("]"):
        var inner := token.substr(1, token.length() - 2).strip_edges()
        var parts := inner.split(" ", false)
        if parts.size() >= 2:
            return [float(parts[0]), float(parts[1])]
    var v := float(token)
    return [v, v]
 
 
## Parse "time,value time,value …" keyframe string.
## Returns the value at time=0 and value at time=1 (first and last keyframe).
func _parse_curve_endpoints(raw: String) -> Array:
    var keyframes := raw.strip_edges().split(" ", false)
    if keyframes.is_empty():
        return [1.0, 1.0]
    var first := keyframes[0].split(",")
    var last  := keyframes[-1].split(",")
    var v0 := float(first[-1]) / 100.0 if first.size() > 1 else float(first[0]) / 100.0
    var v1 := float(last[-1])  / 100.0 if last.size()  > 1 else float(last[0])  / 100.0
    return [v0, v1]
 
 
## Build a simple two-point Curve from start/end values (0-1).
func _make_curve(v_start: float, v_end: float) -> Curve:
    var c := Curve.new()
    c.add_point(Vector2(0.0, v_start))
    c.add_point(Vector2(1.0, v_end))
    return c
 
 
## Split a raw string into its bracket-group or plain tokens.
## e.g. "[100 200] [100 200] [100 200]" → ["[100 200]", "[100 200]", "[100 200]"]
func _split_tokens(raw: String) -> Array:
    var tokens: Array = []
    var i := 0
    raw = raw.strip_edges()
    while i < raw.length():
        if raw[i] == "[":
            var j := raw.find("]", i)
            tokens.append(raw.substr(i, j - i + 1))
            i = j + 1
        elif raw[i] == " ":
            i += 1
        else:
            # plain word token
            var j := raw.find(" ", i)
            if j == -1:
                tokens.append(raw.substr(i))
                break
            tokens.append(raw.substr(i, j - i))
            i = j
    return tokens
 
 
# ── Applying data to CPUParticles2D ──────────────────────────────────────────
 
func _apply(data: Dictionary, p: CPUParticles2D) -> void:
 
    # ── Duration / lifetime ──────────────────────────────────────────────────
    if data.has("SystemDuration"):
        p.lifetime = float(data["SystemDuration"]) / 60.0   # frames → seconds (assume 60 fps)
 
    if data.has("ParticleDuration"):
        var r := _parse_range(data["ParticleDuration"].replace(" ", " "))
        # Use first token as a range
        var tokens := _split_tokens(data["ParticleDuration"])
        if tokens.size() >= 1:
            var rng := _parse_range(tokens[0])
            p.lifetime     = (rng[0] + rng[1]) * 0.5 / 60.0
            p.lifetime_randomness = (rng[1] - rng[0]) / max(rng[1], 1.0)
 
    # ── Emission amount (SpawnMaxActive last keyframe value) ─────────────────
    if data.has("SpawnMaxActive"):
        var keyframes: PackedStringArray = data["SpawnMaxActive"].strip_edges().split(" ", false)
        # Find the peak value across all keyframes
        var peak := 0
        for kf in keyframes:
            var parts := kf.split(",")
            var val := int(parts[-1])
            if val > peak:
                peak = val
        p.amount = max(peak, 1)
 
    # ── Emitter shape ────────────────────────────────────────────────────────
    if data.has("EmitterType"):
        match data["EmitterType"]:
            "Box":
                p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
                var ex := 40.0
                var ey := 25.0
                if data.has("EmitterBoxX"):
                    var rx := _parse_range(data["EmitterBoxX"])
                    ex = abs(rx[1])
                if data.has("EmitterBoxY"):
                    var ry := _parse_range(data["EmitterBoxY"])
                    ey = abs(ry[1])
                p.emission_rect_extents = Vector2(ex, ey)
            "Point":
                p.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINT
            "Circle", "Sphere":
                p.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
 
    # ── Launch speed ─────────────────────────────────────────────────────────
    if data.has("LaunchSpeed"):
        var tokens := _split_tokens(data["LaunchSpeed"])
        if tokens.size() >= 1:
            var rng := _parse_range(tokens[0])
            p.initial_velocity_min = rng[0]
            p.initial_velocity_max = rng[1]
 
    # ── Launch angle ─────────────────────────────────────────────────────────
    if data.has("LaunchAngle"):
        var tokens := _split_tokens(data["LaunchAngle"])
        if tokens.size() >= 1:
            var rng := _parse_range(tokens[0])
            # Convert to Godot's direction (radians, Y-down)
            var mid_deg: float = (rng[0] + rng[1]) * 0.5
            var spread_deg: float = abs(rng[1] - rng[0]) * 0.5
            p.direction   = Vector2.from_angle(deg_to_rad(mid_deg - 90.0))
            p.spread      = spread_deg
 
    # ── Spin ─────────────────────────────────────────────────────────────────
    if data.has("ParticleSpinSpeed"):
        var tokens := _split_tokens(data["ParticleSpinSpeed"])
        if tokens.size() >= 1:
            var rng := _parse_range(tokens[0])
            p.angular_velocity_min = deg_to_rad(rng[0])
            p.angular_velocity_max = deg_to_rad(rng[1])
 
    if data.has("RandomLaunchSpin") and int(data["RandomLaunchSpin"]) == 1:
        p.angle_min = 0.0
        p.angle_max = 360.0
 
    # ── Scale ────────────────────────────────────────────────────────────────
    if data.has("ParticleScale"):
        var tokens := _split_tokens(data["ParticleScale"])
        if tokens.size() >= 1:
            var rng := _parse_range(tokens[0])
            p.scale_amount_min = rng[0]
            p.scale_amount_max = rng[1]
 
    # ── Alpha (particle) ─────────────────────────────────────────────────────
    if data.has("ParticleAlpha"):
        var endpoints := _parse_curve_endpoints(data["ParticleAlpha"])
        p.color_ramp = _make_gradient(endpoints[0], endpoints[1])
 
    # ── Fields (Friction / Acceleration / Gravity) ───────────────────────────
    if data.has("Fields"):
        for field in data["Fields"]:
            match field.get("FieldType", ""):
                "Friction":
                    var fx := float(field.get("X", "0"))
                    var fy := float(field.get("Y", "0"))
                    # Damping in CPUParticles2D is a single value; use the average
                    p.damping_min = (fx + fy) * 0.5 * 60.0
                    p.damping_max = p.damping_min
                "Acceleration", "Gravity":
                    var gx := float(field.get("X", "0"))
                    var gy := float(field.get("Y", "0"))
                    p.gravity = Vector2(gx, gy) * 60.0
 
 
# ── Gradient helper ───────────────────────────────────────────────────────────
 
func _make_gradient(alpha_start: float, alpha_end: float) -> Gradient:
    var g := Gradient.new()
    g.set_color(0, Color(1, 1, 1, alpha_start))
    g.set_color(1, Color(1, 1, 1, alpha_end))
    return g
    
    
func _ready() -> void:
    var path = ""
    load_emitter("", $CPUParticles2D)
        
    
