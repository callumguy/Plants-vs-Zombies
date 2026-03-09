extends Node2D
class_name Animate

@export var parts: Node2D
@onready var body := parts.find_child("Body", true, true)
@onready var eyes: AnimatedSprite2D = parts.find_child("Eyes", true, true)

func blink() -> void:
    if eyes:
        eyes.play("Blink")
    
func squeeze_body(scale: Vector2 = Vector2(1.1, 0.85), time: float = 0.2) -> void:
    var tween = create_tween()
    tween.tween_property(body, "scale", scale, time/2)
    tween.tween_property(body, "scale", Vector2(1, 1), time/2).set_delay(time/2)


    
