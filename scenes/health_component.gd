extends Node2D
class_name Health

signal health_changed(health: int, max_health: int)
signal died

@export var max_health: int = 100
var health: int

func _ready() -> void:
    health = max_health

func take_damage(amount: int) -> void:
    if health == 0:
        return
    if amount == 0:
        return
    
    health = max(health - amount, 0)
    emit_signal("health_changed", health, max_health)
    if health == 0:
        emit_signal("died")

# zombie needs to call take_damage()
# zombie needs to give lane for collisions
