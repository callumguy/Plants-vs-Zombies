extends Plant

@onready var projectile = preload("res://scenes/Projectiles/projectile_spore.tscn")
@onready var shoot_from_sprite = reanim.find_child("PuffShroom_tip")

func perform_action() -> void:
    reanim.play("anim_shooting", false, 3.0)
    shoot.shoot(projectile, raycast)
    
func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_idle", true)
    
func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_shooting":
        reanim.play("anim_idle", true)
