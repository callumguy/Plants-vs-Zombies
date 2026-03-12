extends State
class_name PlantActionState
var plant: Node2D

func enter() -> void:
    plant = actor
    if plant.has_method("perform_action"):
        plant.perform_action()
        plant.reanim.stop(plant.animation_waiting_name)
        plant.reanim.play(plant.animation_action_name)
        #plant.reanim.stop("anim_attack")
        #plant.reanim.play("anim_idle")
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
    
