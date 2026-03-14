extends Plant

var damage: int = 800

func perform_action() -> void:
    var zombie_hurtboxes = get_tree().get_nodes_in_group("zombie_hurtboxes")
    var range = GameManager.CELL_WIDTH * 1.5
    
    for zombie_hurtbox in zombie_hurtboxes:
        var diff = zombie_hurtbox.global_position - global_position
        
        if abs(diff.x) <= range and abs(diff.y) <= range:
            zombie_hurtbox.get_parent().health.take_damage(800)
        
    self.die()
    
func enter_cooldown() -> void:
    pass
    
func enter_waiting() -> void:
    pass

# GameManager.CELL_WIDTH * 3, GameManager.CELL_HEIGHT * 3
