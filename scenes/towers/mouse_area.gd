extends Area2D

func _process(delta: float) -> void:
    var grid_pos = get_global_mouse_position()
    position = grid_pos
    
