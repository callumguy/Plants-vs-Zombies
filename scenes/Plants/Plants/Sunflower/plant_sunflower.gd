extends Plant

@export var sun_amount: int = 50

func perform_action() -> void:
    generate.generate(sun_amount)

#func _ready() -> void:
#    statemachine.change_state("cooldown")
