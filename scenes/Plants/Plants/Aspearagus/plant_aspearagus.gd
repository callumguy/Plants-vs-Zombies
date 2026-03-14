extends Plant

@export var projectile: PackedScene = preload("res://scenes/projectiles/projectile_pea.tscn")
@export var always_shoot: bool = false

func perform_action() -> void:
    reanim.stop("anim_full_idle")
    reanim.play("anim_shooting", false, 2.0)
    
    await get_tree().create_timer(0.25).timeout
    shoot.shoot(projectile, raycast, always_shoot)

func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_full_idle", true)

func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_shooting":
        reanim.play("anim_full_idle", true)
