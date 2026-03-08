extends Marker2D

@onready var sine_value = 90
@onready var pos_y_max = position.y
@onready var pos_y_min = position.y + 20 # high value means lower

func _process(delta: float) -> void:
    sine_value += delta * 80
    var pos_percent = sin(deg_to_rad(sine_value))
    
    var pos_y_dest = lerp(pos_y_min, pos_y_max, pos_percent)
    
    position.y = lerp(position.y, pos_y_dest, 0.05)
