extends Node
class_name Currency

signal currency_changed(new_amount)

@export var starting_amount: int = 50
@onready var currency := starting_amount

func _ready() -> void:
    currency_changed.emit(currency)

func can_afford(cost: int):
    return currency >= cost
    
func spend(cost: int):
    if not can_afford(cost):
        return false
    currency -= cost
    currency_changed.emit(currency)
    return
    
func add(amount):
    currency += amount
    currency_changed.emit(currency)
