extends Node2D
class_name Flash

const FLASH_COOLDOWN: float = 0.5
var on_cooldown: bool = false

@onready var entity := get_parent()
var sprites: Array

func _get_all_sprites() -> Array:
    return entity.find_children("*", "Sprite2D", true, false) + entity.find_children("*", "AnimatedSprite2D", true, false)
    
func flash() -> void:
    if on_cooldown:
        return
    on_cooldown = true
    
    if sprites.is_empty():
        sprites = _get_all_sprites()
    
    for sprite in sprites:
        if not is_instance_valid(sprite): # popped off arm and stuff
            continue
        sprite.modulate = Color(1.2, 1.2, 1.2)
        
    await get_tree().create_timer(0.08).timeout
    
    for sprite in sprites:
        if not is_instance_valid(sprite): # popped off arm and stuff
            continue
        sprite.modulate = Color(1, 1, 1)
    
    await get_tree().create_timer(FLASH_COOLDOWN).timeout
    on_cooldown = false
