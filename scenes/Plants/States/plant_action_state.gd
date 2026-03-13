extends State
class_name PlantActionState
var plant: Node2D

func enter() -> void:
    plant = actor
    if plant.has_method("perform_action"):
        plant.perform_action()
        plant.reanim.stop(plant.animation_waiting_name)
        for animation_name in plant.animation_action_names:
            plant.reanim.play(animation_name)
            
    state_machine.change_state("cooldown")
    
func exit() -> void:
    pass
    
func update(delta: float) -> void:
    pass
    
func physics_update(delta: float) -> void:
    pass
    
func handle_input(event: InputEvent) -> void:
    pass
    
