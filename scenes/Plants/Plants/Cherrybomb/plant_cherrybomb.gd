extends Plant

var damage: int = 800

func perform_action() -> void:
    reanim.play("anim_explode")
    
    await get_tree().create_timer(1).timeout
    $Sprite2D.global_position = global_position
    
    var targets = splash.get_targets(global_position)
    
    for target in targets:
        target.get_parent().take_damage(damage) # target's parent should be HurtboxComponent
    
    #var zombie_hurtboxes = get_tree().get_nodes_in_group("zombie_hurtboxes")
    #var range = GameManager.CELL_WIDTH * 1.5
    #
    #for zombie_hurtbox in zombie_hurtboxes:
        #var diff = zombie_hurtbox.global_position - global_position
        #
        #if abs(diff.x) <= range and abs(diff.y) <= range:
            #zombie_hurtbox.get_parent().health.take_damage(800)
    
func enter_cooldown() -> void:
    pass
    
func enter_waiting() -> void:
    pass

func animation_finished(animation_name: String) -> void:
    if animation_name == 'anim_explode':
        self.die()


# GameManager.CELL_WIDTH * 3, GameManager.CELL_HEIGHT * 3
