extends Plant

const DAMAGE: int = 800

func _process(delta: float) -> void:
    print("ya")
    if len(reanim.current_animations) == 0:
        print("yee")
        reanim.play("anim_idle")
        
func animation_finished(animation_name: String) -> void:
    if animation_name == 'anim_idle':
        reanim.play("anim_explode", false)
    if animation_name == 'anim_explode':
        
        var x_location = GridManager.LAWN_LEFT + GridManager.LAWN_WIDTH / 2 # center of lawn
        var location = Vector2(x_location, global_position.y)
        
        var targets = scan.get_targets(location, Vector2(9, 1), 2)
        for target in targets:
            if target.get_parent().get_parent().lane == lane:
                target.get_parent().take_damage(800)
        
        AudioManager.play_sfx(SoundDatabase.PLANTS.jalapeno_explode, -6.0)
        self.die()
