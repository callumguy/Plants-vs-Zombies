extends Node2D
class_name Clickable

@onready var parent: RigidBody2D = get_parent()

func _ready() -> void:
    parent.input_event.connect(_on_input)

func _on_input():
    pass
    
