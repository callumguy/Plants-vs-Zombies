extends Node2D

# @onready var sprite = $AnimatedSprite2D

# @export var duration := 0.1 # seconds

func _ready():
    var sprite = $AnimatedSprite2D
    
    sprite.play("hit")
    await sprite.animation_finished
    queue_free()
