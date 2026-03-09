extends Node2D
class_name Generate

@onready var plant = get_parent()
@onready var sun_folder = get_tree().current_scene.find_child("SunFolder")
@onready var sun_scene = preload("res://scenes/sun.tscn")

func generate(amount: int) -> void:
    var sun = sun_scene.instantiate()
    sun.global_position = plant.global_position
    sun.lane = plant.lane
    sun.column = plant.column
    sun.sun_amount = amount
    sun_folder.add_child(sun)
    sun.spawn_movement()
