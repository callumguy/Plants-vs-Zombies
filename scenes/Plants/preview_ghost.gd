extends Node2D

func _process(delta: float) -> void:
    var grid_pos = GameManager.get_grid_position(get_global_mouse_position())
    position = grid_pos
    
    if position == Vector2.ZERO and visible == true:
        visible = false
    elif position != Vector2.ZERO and visible == false:
        visible = true
    
    
