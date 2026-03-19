extends Node2D

func _process(delta: float) -> void:
    if not GridManager:
        return
        
    var grid_pos = GridManager.pos_to_grid_pos(get_global_mouse_position())
    position = grid_pos
    
    if position == Vector2(-1, -1) and visible == true:
        visible = false
    elif position != Vector2(-1, -1) and visible == false:
        visible = true
    
    
