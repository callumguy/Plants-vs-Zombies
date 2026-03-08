extends Node2D
class_name Movement

@export var base_speed: float = 15
@export var direction: Vector2 = Vector2.LEFT
@export var character: CharacterBody2D
var speed: float

func _ready() -> void:
    base_speed = randf_range(base_speed - 1, base_speed + 1)
    speed = base_speed
    
func _physics_process(delta: float) -> void:
    character.velocity = direction * speed
    character.move_and_slide()
