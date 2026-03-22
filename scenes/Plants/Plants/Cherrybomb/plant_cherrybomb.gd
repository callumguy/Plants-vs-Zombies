extends Plant

var damage: int = 800

func perform_action() -> void:
    reanim.play("anim_explode")
    
func enter_cooldown() -> void:
    pass
    
func enter_waiting() -> void:
    pass

func animation_finished(animation_name: String) -> void:
    if animation_name == 'anim_explode':
        
        var targets = splash.get_targets(global_position)
        for target in targets:
            if target.get_parent().get_parent().lane in range(lane -1, lane + 2): # jank
                target.get_parent().take_damage(damage) # target's parent should be HurtboxComponent
                
    AudioManager.play_sfx(SoundDatabase.PLANTS['cherrybomb_explode'], -6.0)
    self.die()


# GameManager.CELL_WIDTH * 3, GameManager.CELL_HEIGHT * 3
