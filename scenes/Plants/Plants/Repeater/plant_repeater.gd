extends Plant

var projectile: PackedScene = preload(ScenePaths.PROJECTILE_PEA)
var always_shoot: bool = false

var idle_previous_frame: int

func perform_action() -> void:
    idle_previous_frame = reanim.stop("anim_head_idle")
    reanim.play("anim_shooting", false, 3.0)
    shoot.shoot(projectile, raycast, always_shoot)
    #shoot.new_shoot(projectile, global_position, Vector2.RIGHT)
    AudioManager.play_sfx(SoundDatabase.PLANTS['peashooter_shoot'])
    
func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_idle", true)
        reanim.play("anim_head_idle", true)
    
func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_shooting":
        # reanim.play("anim_full_idle", true, 1.0, idle_previous_frame)
        reanim.play("anim_head_idle", true)
