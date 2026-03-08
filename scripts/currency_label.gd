extends Label

@onready var currency: Currency = get_tree().current_scene.find_child("CurrencyComponent")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    text = str(floor(currency.currency))
    currency.currency_changed.connect(_on_currency_changed)

func _on_currency_changed(new_amount):
    text = str(floor(new_amount))
    print(str(new_amount))
