extends State
class_name PlantActionState
var plant: Node2D

func enter() -> void:
    plant = actor
    if plant.has_method("perform_action"):
        plant.perform_action()
        # maybe a wait needed?
    state_machine.change_state("cooldown")
    
func exit() -> void:
    pass
    
func update(delta: float) -> void:
    pass
    
func physics_update(delta: float) -> void:
    pass
    
func handle_input(event: InputEvent) -> void:
    pass
    
