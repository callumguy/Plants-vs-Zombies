extends Node2D
class_name Hurtbox

signal damaged(amount: int)
@export var hurtbox: Area2D

func _ready() -> void:
    hurtbox.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
    if area.has_method("get_damage"):
        var damage = area.get_damage()
        damaged.emit(damage)
        




    
