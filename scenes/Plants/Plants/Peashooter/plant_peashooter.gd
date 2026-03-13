extends Plant

@export var projectile: PackedScene = preload("res://scenes/projectiles/projectile_pea.tscn")
@export var always_shoot: bool = false

func perform_action() -> void:
    #var frame_ended_on: int = reanim.stop("anim_full_idle")
    #print(frame_ended_on)
    reanim.stop("anim_full_idle")
    reanim.stop("anim_head_idle")
    reanim.play("anim_shooting")
    
    shoot.shoot(projectile, raycast, always_shoot)

func enter_cooldown() -> void:
    #if len(reanim.current_animations) == 0:
    #    reanim.play("anim_full_idle", true)
    #    reanim.play("anim_head_idle", true)
    
    # reanim.play("anim_full_idle", true)
    # reanim.play("anim_head_idle", true)
    # var frame_ended_on: int = reanim.stop("anim_idle")
    # reanim.play("anim_full_idle", true, frame_ended_on)
    pass
    
func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_shooting":
        # reanim.play("anim_full_idle", true)
        # reanim.play("anim_idle", true)
        reanim.play("anim_head_idle", true)
        reanim.play("anim_full_idle", true)
