extends Plant

@export var projectile: PackedScene = preload("res://scenes/projectiles/projectile_pea.tscn")
@export var always_shoot: bool = false

func perform_action() -> void:
    if animate:
        animate.blink()
    
    shoot.shoot(projectile, raycast, always_shoot)
