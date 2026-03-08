extends Node2D
class_name Despawn

@onready var despawnee = get_parent()

func despawn(duration: float = 2.0, fade_duration: float = 0.5) -> void:
    
    await get_tree().create_timer(duration - fade_duration).timeout
    var tween = create_tween()
    tween.tween_property(despawnee, "modulate:a", 0.0, fade_duration)
    
    await get_tree().create_timer(fade_duration).timeout
    despawnee.queue_free()
