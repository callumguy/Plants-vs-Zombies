extends Node2D
class_name DamageVisuals

@export var sprite: AnimatedSprite2D
@export var stages : Array = [0.66, 0.33]

func _ready() -> void:
    var health = get_parent().get_node("Health")
    

func _on_health_changed(current_health, max_health) -> void:
    var ratio = float(current_health) / max_health
    var sprite_frame = 0
    
    for threshold in stages:
        if ratio < threshold: # passes this for every threshold higher than current health ratio
            sprite_frame += 1 # more broken
            
    sprite.frame = sprite_frame
    
