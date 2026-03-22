extends Node2D
class_name DamageVisuals

@export var sprite: Sprite2D
@export var stages : Array = [0.66, 0.33]
@export var stageImages : Array = ["", ""]

func _ready() -> void:
    var health = get_parent().get_node("Health")
    

func _on_health_changed(current_health, max_health) -> void:
    var ratio = float(current_health) / max_health
    var frame = -1
    
    for threshold in stages:
        print(threshold, "", ratio)
        if ratio < threshold: # passes this for every threshold higher than current health ratio
            frame += 1 # more broken
    
    if frame > -1:
        var image = AnimationData.get_reanim_image(stageImages[frame])
        sprite.texture = image
    
    #if sprite:
    #    sprite.frame = sprite_frame
    
